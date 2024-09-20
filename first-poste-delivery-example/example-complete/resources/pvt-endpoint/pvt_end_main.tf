resource "azurerm_public_ip" "public_ip" {
  name                = "pip-${var.name}"
  sku                 = var.sku
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "load_balancer" {
  name                = "example-lb"
  sku                 = "Standard"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = azurerm_public_ip.public_ip.name
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_private_link_service" "pvt_link_srv" {
  name                = "privatelink-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  # TODO
  load_balancer_frontend_ip_configuration_ids = [
    azurerm_lb.load_balancer.frontend_ip_configuration.0.id,
  ]
  nat_ip_configuration {
    name      = azurerm_public_ip.public_ip.name
    primary   = true
    subnet_id = var.subnet_id
  }

}

resource "azurerm_private_endpoint" "pvt_endpoint" {
  name                = "pvt-endpoint-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "privatelink-${var.name}"
    private_connection_resource_id = azurerm_private_link_service.pvt_link_srv.id
    is_manual_connection           = var.is_manual_connection
  }
}