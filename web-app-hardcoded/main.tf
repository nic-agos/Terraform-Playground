#Create azure resource group
resource "azurerm_resource_group" "terraform_lab_rg" {
  provider = azurerm
  name     = "TERRAFORM_LAB"
  location = local.azure_region

  lifecycle {
    prevent_destroy = false
  }
}

#Create virtual network for the VM
resource "azurerm_virtual_network" "server_vnet" {
  provider            = azurerm
  name                = "${var.prefix}-web_server_vNet"
  location            = local.azure_region
  resource_group_name = azurerm_resource_group.terraform_lab_rg.name
  address_space       = ["192.168.0.0/24"]
  tags = {
    "Scope" = "Terraform",
    "Name"  = "web_server_vNet"
  }
}

#Create subnet to the virtual network
resource "azurerm_subnet" "server_subnet" {
  provider             = azurerm
  name                 = "${var.prefix}-web_server_subnet"
  resource_group_name  = azurerm_virtual_network.server_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.server_vnet.name
  address_prefixes     = ["192.168.0.0/24"]
}

#Create public ip
resource "azurerm_public_ip" "server_pip" {
  provider            = azurerm
  name                = "${var.prefix}-server-public-ip"
  location            = local.azure_region
  resource_group_name = azurerm_resource_group.terraform_lab_rg.name
  allocation_method   = "Dynamic"
  #domain_name_label   = var.hostname

  tags = {
    "Scope" = "Terraform",
    "Name"  = "server-public-ip"
  }

}

#Create Network interface
resource "azurerm_network_interface" "server_nw_iface" {
  provider            = azurerm
  name                = "${var.prefix}-web_server_nw_iface"
  location            = local.azure_region
  resource_group_name = azurerm_virtual_network.server_vnet.resource_group_name

  ip_configuration {
    name                          = "${var.prefix}-internal"
    subnet_id                     = azurerm_subnet.server_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.server_pip.id
  }
  tags = {
    "Scope" = "Terraform",
    "Name"  = "server_network_interface"
  }
}

#Create Network security group
resource "azurerm_network_security_group" "allow_HTTP_and_SSH" {
  provider            = azurerm
  name                = "${var.prefix}-web_server_nsg"
  location            = local.azure_region
  resource_group_name = azurerm_virtual_network.server_vnet.resource_group_name
  security_rule {
    name                       = "HTTP from external"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "SSH from external"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    "Scope" = "Terraform"
    "Name"  = "web_server_nsg"
  }
}

/* 
Double level of security group, one at subnet level and the second at VM interface level
 - For inbound traffic, Azure processes the rules in a network security group associated to a subnet first, 
   if there is one, and then the rules in a network security group associated to the network interface, if there is one.

 - For outbound traffic, Azure processes the rules in a network security group associated to a network interface first, 
   if there is one, and then the rules in a network security group associated to the subnet, if there is one.
*/
# Connect the security group to the subnet
resource "azurerm_subnet_network_security_group_association" "nsg_sub" {
  provider                  = azurerm
  subnet_id                 = azurerm_subnet.server_subnet.id
  network_security_group_id = azurerm_network_security_group.allow_HTTP_and_SSH.id
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsg_nw_iface" {
  provider                  = azurerm
  network_interface_id      = azurerm_network_interface.server_nw_iface.id
  network_security_group_id = azurerm_network_security_group.allow_HTTP_and_SSH.id
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  #provider = azurerm
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create storage account for boot diagnostics
/*resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.terraform_lab_rg.name
    location                    = "westeurope"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Terraform Demo"
    }
}*/

#Create a Linux VM
resource "azurerm_linux_virtual_machine" "myterraformvm" {
  provider              = azurerm
  name                  = "${var.prefix}-myVM"
  location              = local.azure_region
  resource_group_name   = azurerm_resource_group.terraform_lab_rg.name
  network_interface_ids = [azurerm_network_interface.server_nw_iface.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  admin_password                  = "Password1!"
  disable_password_authentication = false

  /*admin_ssh_key {
      username       = "azureuser"
      public_key     = tls_private_key.example_ssh.public_key_openssh
  }*/

  /*boot_diagnostics {
      storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }*/

  tags = {
    #"environment" = "Terraform Demo",
    "Scope" = "Terraform",
    "Name"  = "web_server_nsg"
  }

  custom_data = filebase64("./init.sh")
}