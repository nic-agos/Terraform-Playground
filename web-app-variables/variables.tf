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

# Resource group variables
variable "rg_name" {
  type        = string
  description = "The name of the resource group that hosts all the deployed resources"
  default     = "TERRAFORM_LAB"
}

# Vnet variables
variable "vnet_address_space" {
  type        = list(string)
  description = "The list of Vnet address spaces"
  default     = ["192.168.0.0/24"]
}

# Subnet variables
variable "subnet_address_space" {
  type        = list(string)
  description = "The Subnet address space"
  default     = ["192.168.0.0/24"]
}

# Public-IP variables
variable "pip_hostname" {
  type        = string
  description = "The hostname related to the puclic-IP"
  default     = "test.terraform"
}

# TLS private key variables
variable "tls_algorithm" {
  type        = string
  description = "The chiper method used for authenitcation purpose"
  default     = "RSA"
}

variable "tls_RSA_bits" {
  type        = number
  description = "The chiper method used for authenitcation purpose"
  default     = 4096
}

# Linux VM variables
variable "vm_linux_size" {
  type        = string
  description = "The VM instance type"
  default     = "Standard_B1s"
}

variable "vm_linux_os_disk" {
  type = object({
    name                 = string
    caching              = string
    storage_account_type = string
  })
  description = "The VM OS disk type"
  default = {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
}

variable "vm_linux_source_image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "The VM source image type"
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "vm_linux_computer_name" {
  type        = string
  description = "The VM hostname"
  default     = "myvm"
}

variable "vm_linux_admin_user" {
  type        = string
  description = "The VM instance type"
  default     = "azureuser"
}

variable "vm_linux_admin_pwd" {
  type        = string
  description = "The VM instance type"
  default     = "Password1!"
}

variable "vm_linux_disable_pwd_auth" {
  type        = bool
  description = "The VM instance type"
  default     = false
}

variable "default_tags" {
  default = {
    "Scope" = "Terraform"
  }
  description = "Additional resource tags"
  type        = map(string)
}