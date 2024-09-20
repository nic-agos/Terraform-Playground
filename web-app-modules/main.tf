module "rg" {
  source   = "./resources/rg"
  prefix   = var.prefix
  location = local.azure_region
  providers = {
    azurerm = azurerm
  }
  tags = var.tags
}

module "network" {
  /*source  = "Azure/network/azurerm"
  version = "3.5.0"*/
  source              = "./resources/network"
  prefix              = var.prefix
  location            = local.azure_region
  resource_group_name = module.rg.resource_group_name
  address_space       = var.vnet_address_space
  subnets             = var.subnet_address_space
  network_rules       = var.network_rules
  providers = {
    azurerm = azurerm
  }
  tags = var.tags
}

module "vml-0" {
  source                    = "./resources/vml"
  prefix                    = var.prefix
  location                  = local.azure_region
  resource_group_name       = module.rg.resource_group_name
  subnet_id                 = module.network.vnet_subnets[0]
  vm_linux_size             = var.vm_linux_size
  vm_linux_os_disk          = var.vm_linux_os_disk
  vm_linux_source_image     = var.vm_linux_source_image
  vm_linux_computer_name    = var.vm_linux_computer_name
  vm_linux_admin_user       = var.vm_linux_admin_user
  vm_linux_admin_pwd        = var.vm_linux_admin_pwd
  vm_linux_disable_pwd_auth = var.vm_linux_disable_pwd_auth
  providers = {
    azurerm = azurerm
  }
  tags = var.tags
}