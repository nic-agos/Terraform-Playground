variable "prefix" {
  type        = string
  description = "The prefix used for all resources in this example"
  default     = "TerraDemo"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "address_space" {
  type        = list(string)
  description = "The list of Vnet address spaces"
}

variable "subnets" {
  description = "Map of Azure VNET subnet configuration"
  type        = list(string)
}

variable "network_rules" {
  type = list(object(
    {
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }
  ))
}

variable "tags" {
}