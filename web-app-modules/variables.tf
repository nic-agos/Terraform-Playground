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

variable "network_rules" {
  default = [
    {
      name                       = "HTTP from external"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "SSH from external"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

# Public-IP variables
variable "pip_hostname" {
  type        = string
  description = "The hostname related to the puclic-IP"
  default     = "test.terraform"
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

variable "tags" {
  default = {
    "Scope" = "Terraform"
  }
  description = "Additional resource tags"
  type        = map(string)
}