#Create azure resource group
resource "azurerm_resource_group" "rg" {
  provider = azurerm
  name     = "TERRAFORM_LAB"
  location = local.azure_region

  lifecycle {
    prevent_destroy = false
  }
}

# Create multiple storage account using count
resource "azurerm_storage_account" "sa-count" {
  count = lenght(var.indexes)
 
  name                     = "jbtterraformdemo-${count.index}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  account_tier             = "Standard"
}

#Create multiple storage account using for_each
resource "azurerm_storage_account" "sa-for-each" {
  for_each                 = var.stgaccts

  name                     = each.value.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = each.value.location
  account_kind             = each.value.kind
  account_replication_type = each.value.repl
  account_tier             = each.value.tier
}