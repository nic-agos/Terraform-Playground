#Create azure resource group
resource "azurerm_resource_group" "terraform_lab_rg" {
  provider = azurerm
  name     = var.rg_name
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
  address_space       = var.vnet_address_space

  tags = merge(
    var.default_tags,
    {
      "Name" = "web_server_vNet"
    },
  )
}

#Create subnet to the virtual network
resource "azurerm_subnet" "server_subnet" {
  provider             = azurerm
  name                 = "${var.prefix}-web_server_subnet"
  resource_group_name  = azurerm_virtual_network.server_vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.server_vnet.name
  address_prefixes     = var.subnet_address_space
}

#Create public ip
resource "azurerm_public_ip" "server_pip" {
  provider            = azurerm
  name                = "${var.prefix}-server-public-ip"
  location            = local.azure_region
  resource_group_name = azurerm_resource_group.terraform_lab_rg.name
  allocation_method   = "Dynamic"
  #domain_name_label   = var.hostname

  tags = merge(
    var.default_tags,
    {
      "Name" = "server-public-ip"
    },
  )
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

  tags = merge(
    var.default_tags,
    {
      "Name" = "server_network_interface"
    },
  )
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

  tags = merge(
    var.default_tags,
    {
      "Name" = "web_server_nsg"
    },
  )
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
  algorithm = var.tls_algorithm
  rsa_bits  = var.tls_RSA_bits
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
  size                  = var.vm_linux_size

  os_disk {
    name                 = var.vm_linux_os_disk.name
    caching              = var.vm_linux_os_disk.caching
    storage_account_type = var.vm_linux_os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.vm_linux_source_image.publisher
    offer     = var.vm_linux_source_image.offer
    sku       = var.vm_linux_source_image.sku
    version   = var.vm_linux_source_image.version
  }

  computer_name                   = var.vm_linux_computer_name
  admin_username                  = var.vm_linux_admin_user
  admin_password                  = var.vm_linux_admin_pwd
  disable_password_authentication = var.vm_linux_disable_pwd_auth

  /*admin_ssh_key {
      username       = "azureuser"
      public_key     = tls_private_key.example_ssh.public_key_openssh
  }*/

  /*boot_diagnostics {
      storage_account_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
  }*/

  tags = merge(
    var.default_tags,
    {
      "Name" = "web_server_nsg"
    },
  )

  custom_data = filebase64("./init.sh")
}