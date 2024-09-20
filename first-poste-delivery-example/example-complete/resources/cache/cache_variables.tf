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

variable "capacity" {
  type        = number
  description = "The size of the Redis cache to deploy"
}

variable "family" {
  type        = string
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)"
}

variable "cache_sku_name" {
  type        = string
  description = "The SKU of Redis to use. Possible values are Basic, Standard and Premium"
}

variable "enable_non_ssl_port" {
  type        = bool
  description = "Enable the non-SSL port (6379)"
}

variable "minimum_tls_version" {
  type        = string
  description = "The minimum TLS version"
}

variable "private_static_ip_address" {
  type        = string
  description = "The Static IP Address to assign to the Redis Cache when hosted inside the Virtual Network"
}