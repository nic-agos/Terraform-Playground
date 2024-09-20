resource "azurerm_subnet" "subnet" { # change to "subnet", as well as references?
  # Discriminates for each loop on the subnet role string ("fe", "be", "mw")
  provider = azurerm
  # index() -> retrive the index of an element of the list
  name                 = "${var.prefix}-sub"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_prefixes     = var.subnets[0]
}