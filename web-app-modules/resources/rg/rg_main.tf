resource "azurerm_resource_group" "rg" {
  provider = azurerm
  name     = "${var.prefix}-rg"
  location = var.location
  tags = merge(
    var.tags,
    {
      #Tag = Value
    }
  )
}