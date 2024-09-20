resource "azurerm_virtual_network" "vnet" {
  provider            = azurerm
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space

  tags = merge(var.tags,
    {
      #Tag = Value
    }
  )
}

resource "azurerm_subnet" "vnet" { # change to "subnet", as well as references?
  # Discriminates for each loop on the subnet role string ("fe", "be", "mw")
  provider = azurerm
  for_each = toset(var.subnets)
  # index() -> retrive the index of an element of the list
  name                 = "${var.prefix}-sub-${index(var.subnets, each.value) + 1}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value]
}

resource "azurerm_network_security_group" "nsg" {
  provider = azurerm
  # Create one security group for each subnet, each security group will have associate the subnet CIDR as key
  for_each            = toset(var.subnets)
  name                = "${var.prefix}-nsg-${index(var.subnets, each.value) + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name

  # dynamic is used to cycle inside blocks -> blocks are basic repeatable object of terraform
  dynamic "security_rule" {
    for_each = { for rule in var.network_rules : rule.name => rule }
    content {
      # security_rule.key -> prendo il valore della chiave (in questo caso rule.name), security_rule.value -> prendo il valore puntato dalla chiave 
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = merge(var.tags,
    {
      #Tag = Value
    }
  )
}

resource "azurerm_subnet_network_security_group_association" "nsg" {
  provider = azurerm
  # The cicle is performed on the variable (subnet) used as index to create subnets and nsgs.
  # Performing this cycle and using the same variable as index allows to get from each list the right component, regardless its position
  for_each                  = toset(var.subnets)
  subnet_id                 = lookup(azurerm_subnet.vnet, each.value).id
  network_security_group_id = lookup(azurerm_network_security_group.nsg, each.value).id
}