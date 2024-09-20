# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "redis_cache" {
  name                      = "redis-cache-${var.name}"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  capacity                  = var.capacity
  family                    = var.family
  sku_name                  = var.cache_sku_name
  enable_non_ssl_port       = var.enable_non_ssl_port
  minimum_tls_version       = var.minimum_tls_version
  private_static_ip_address = var.private_static_ip_address
  redis_configuration {

  }
}