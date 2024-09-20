locals {
  input              = jsondecode(file("../secrets.json"))
  azure_subscription = local.input.AzureSubscription
  azure_region       = local.input.AzureRegion
}

variable "name_xol" {
  type        = string
  description = "The prefix used for all resources in this example"
}

# The resource group name already created in Azure
# get the value from Azure directly and put into the tfvars file
variable "existing_rg_name" {
  type        = string
  description = "The name of the resource group manually created in Azure"
}

# The VNET name already created in Azure
# get the value from Azure directly and put into the tfvars file
variable "vnet_name" {
  type        = string
  description = "The name of the VNET imported with the data structure"
}

# Subnet variables
variable "subnet_address_space" {
  type        = list(string)
  description = "The Subnet address space"
  default     = ["10.1.0.0/24"]
}

# Public_IP variables
variable "pip_hostname" {
  type        = string
  description = "The hostname related to the puclic_IP"
  default     = "test.terraform"
}

# Redis cache variables 
variable "cache_name" {
  type       = string
  descrption = "The name of the redis cluster instance"
  default    = "sxolbercache01azne"
}

variable "cache_capacity" {
  type        = number
  description = "The size of the Redis cache to deploy"
  default     = 1
}

variable "cache_family" {
  type        = string
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)"
  default     = "C"
}

variable "cache_sku_name" {
  type        = string
  description = "The SKU of Redis to use. Possible values are Basic, Standard and Premium"
  default     = "Basic"
}

variable "cache_enable_non_ssl_port" {
  type        = bool
  description = "Enable the non_SSL port (6379)"
  default     = false
}

variable "cache_minimum_tls_version" {
  type        = string
  description = "The minimum TLS version"
}

# private_endpoint variables
variable "sku" {
  type        = string
  description = " The SKU of the Public IP"
}

variable "is_manual_connection" {
  type        = bool
  description = " Does the Private Endpoint require Manual Approval from the remote resource owner?"
}

variable "tags" {
  default = {
    "Scope"    = "Terraform"
    "Owner"    = "Pippo"
    "app-name" = "ecommerce"
  }
  description = "Additional resource tags"
  type        = map(string)
}