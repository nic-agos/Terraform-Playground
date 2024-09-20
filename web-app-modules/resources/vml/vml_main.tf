#Create public ip
resource "azurerm_public_ip" "server_pip" {
  provider            = azurerm
  name                = "${var.prefix}-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  #domain_name_label   = var.hostname

  tags = merge(
    var.tags,
    {
      "Name" = "server-public-ip"
    },
  )
}

#Create Network interface
resource "azurerm_network_interface" "server_nw_iface" {
  provider            = azurerm
  name                = "${var.prefix}-web_server_nw_iface"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.prefix}-internal-nic"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.server_pip.id
  }

  tags = merge(
    var.tags,
    {
      "Name" = "server_network_interface"
    },
  )
}

#Create a Linux VM
resource "azurerm_linux_virtual_machine" "myterraformvm" {
  provider              = azurerm
  name                  = "${var.prefix}-VM"
  location              = var.location
  resource_group_name   = var.resource_group_name
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
    var.tags,
    {
      "Name" = "web_server_nsg"
    },
  )

  custom_data = filebase64("./init.sh")
}