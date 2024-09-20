output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The Name of the newly created vNet"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = azurerm_virtual_network.vnet.address_space
}

output "vnet_subnets" {
  description = "The ids of subnets created inside the newly vNet"
  value       = tolist([for vnet in azurerm_subnet.vnet : vnet.id])
}

output "nsg_subnets" {
  description = "The ids of nsg created inside the newly vNet"
  value       = [for nsg in azurerm_network_security_group.nsg : { name = nsg.name, id = nsg.id }]
}