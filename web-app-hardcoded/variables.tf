locals {
  input              = jsondecode(file("./secrets.json"))
  azure_subscription = local.input.AzureSubscription
  azure_region       = local.input.AzureRegion
}

variable "prefix" {
  type        = string
  description = "The prefix used for all resources in this example"
  default     = "TerraDemo"
}