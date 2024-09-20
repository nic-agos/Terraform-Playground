locals {
  input              = jsondecode(file("../secrets.json"))
  azure_subscription = local.input.AzureSubscription
  azure_region       = local.input.AzureRegion
}

variable "name_xol" {
  type        = string
  description = "The prefix used for all resources in this example"
}

variable "existing_rg_name" {
  type        = string
  description = "The name of the resource group manually created in Azure"
}

variable "vnet_name" {
  type        = string
  description = "The name of the VNET imported with the data structure"
}

# Subnet variables
variable "subnet_address_space" {
  type        = list(string)
  description = "The Subnet address space"
}

# Public_IP variables
variable "pip_hostname" {
  type        = string
  description = "The hostname related to the puclic_IP"
  default     = "test.terraform"
}

# Redis cache variables 
variable "cache_name" {
  type        = string
  description = "The name of the redis cluster instance"
}

variable "cache_capacity" {
  type        = number
  description = "The size of the Redis cache to deploy"
}

variable "cache_family" {
  type        = string
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)"
}

variable "cache_sku_name" {
  type        = string
  description = "The SKU of Redis to use. Possible values are Basic, Standard and Premium"
}

variable "cache_enable_non_ssl_port" {
  type        = bool
  description = "Enable the non_SSL port (6379)"
}

variable "cache_minimum_tls_version" {
  type        = string
  description = "The minimum TLS version"
}

# private_endpoint variables
variable "pvt_end_sku" {
  type        = string
  description = " The SKU of the Public IP"
}

variable "is_manual_connection" {
  type        = bool
  description = " Does the Private Endpoint require Manual Approval from the remote resource owner?"
}

variable "tags" {
  description = "Additional resource tags"
  type        = map(string)
}