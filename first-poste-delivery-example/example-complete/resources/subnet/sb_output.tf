output "subnet_id" {
  description = "The subnet ID"
  value       = { for k, v in azurerm_subnet.subnet : v.name => v.id }
}