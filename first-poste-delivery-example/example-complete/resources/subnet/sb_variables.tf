variable "prefix" {
  type        = string
  description = "The prefix used for all resources in this example"
  default     = "TerraDemo"
}

variable "resource_group_name" {
  type = string
}

variable "subnets" {
  description = "Map of Azure VNET subnet configuration"
  type        = list(string)
}

variable "vnet_name" {
  description = "The VNET where the subnet is associated"
  type        = string
}

variable "tags" {

}