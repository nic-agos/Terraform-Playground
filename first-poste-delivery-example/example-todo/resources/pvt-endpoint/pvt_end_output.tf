output "private_endpoint_ip" {
  description = "The private IP address associated with the private endpoint"
  value       = azurerm_private_endpoint.pvt_endpoint.private_service_connection[0].private_ip_address
}