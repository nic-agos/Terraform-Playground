#Create azure resource group
resource "azurerm_resource_group" "rg" {
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
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["192.168.0.0/16"]
  tags = {
    "Scope" = "Terraform",
    "Name"  = "web_server_vNet"
  }
}

#Create subnet to the virtual network
resource "azurerm_subnet" "server_subnet" {
  provider             = azurerm
  # we are going to create a map from a list, with subnet.name as the key and subnet.prefix as the value
  for_each             = {for subnet in var.subnets: subnet.name => subnet.address_prefix}
  name                 = "${var.prefix}-web_server_subnet-${each.key}"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.server_vnet.name
  address_prefixes     = [each.value]
}

#Create Network security group
resource "azurerm_network_security_group" "example" {
  provider            = azurerm
  for_each            = {for subnet in var.subnets: subnet.name => subnet.address_prefix}
  name                = "${var.prefix}-web_server_nsg-${each.key}"
  location            = local.azure_region
  resource_group_name = azurerm_resource_group.rg.name
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
  tags = {
    "Scope" = "Terraform"
    "Name"  = "web_server_nsg"
  }
}

# Connect the security group to the subnet
resource "azurerm_subnet_network_security_group_association" "nsg_sub" {
  provider                  = azurerm
  for_each                  = {for subnet in var.subnets: subnet.name => subnet.address_prefix}
  subnet_id                 = lookup(azurerm_subnet.server_subnet, each.key).id
  network_security_group_id = lookup(azurerm_network_security_group.example, each.key).id
}