data "azurerm_resource_group" "rg-VNET-AUTOMATION" {
  name = var.existing_rg_name
}

data "azurerm_virtual_network" "vnet-VNET-AUTOMATION" {
  name = var.vnet_name
  #resource_group_name = "VNET-AUTOMATION"
  resource_group_name = data.azurerm_resource_group.rg-VNET-AUTOMATION.name
}

module "rg" {
  source   = "../resources/rg"
  prefix   = var.name_xol
  location = local.azure_region
  providers = {
    azurerm = azurerm
  }
  tags = var.tags
}

/* module "rg-RG-XOL-COLL" {
  source   = "./resources/rg"
  prefix   = var.name-xol-coll
  location = local.azure_region
  providers = {
    azurerm = azurerm
  }
  tags = var.tags
} */

module "subnet" {
  source              = "../resources/subnet"
  prefix              = var.name_xol
  resource_group_name = data.azurerm_resource_group.rg-VNET-AUTOMATION.name
  vnet_name           = data.azurerm_virtual_network.vnet-VNET-AUTOMATION.id
  subnets             = var.subnet_address_space
  providers = {
    azurerm = azurerm
  }
  tags = var.tags
}

module "private-endpoint" {
  source               = "../resources/pvt-endpoint"
  name                 = var.name_xol
  resource_group_name  = data.azurerm_resource_group.rg-VNET-AUTOMATION.name
  location             = local.azure_region
  sku                  = var.pvt_end_sku
  is_manual_connection = var.is_manual_connection
  subnet_id            = lookup(module.subnet.subnet_id, "RG-XOL-COLL-sub-1", "not found")
}

module "redis-cache" {
  source                    = "../resources/cache"
  resource_group_name       = data.azurerm_resource_group.rg-VNET-AUTOMATION.name
  location                  = local.azure_region
  name                      = var.cache_name
  capacity                  = var.cache_capacity
  family                    = var.cache_family
  cache_sku_name            = var.cache_sku_name
  enable_non_ssl_port       = var.cache_enable_non_ssl_port
  minimum_tls_version       = var.cache_minimum_tls_version
  private_static_ip_address = module.private-endpoint.private_endpoint_ip
}