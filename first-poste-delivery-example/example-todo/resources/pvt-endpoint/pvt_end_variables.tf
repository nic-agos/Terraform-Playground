variable "name" {
  type        = string
  description = "The name of the redis cluster instance"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that hosts all the deployed resources"
}

variable "sku" {
  type        = string
  description = " The SKU of the Public IP"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint"
}

variable "is_manual_connection" {
  type        = bool
  description = " Does the Private Endpoint require Manual Approval from the remote resource owner?"
}