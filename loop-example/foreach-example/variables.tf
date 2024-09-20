variable "subnets" {
  type = list(object(
     {
      name             = string
      address_prefix   = string
    }
  ))
  description = "The list of subnets to create in the same VNET"
  default = [ 
  {
    address_prefix = "192.168.1.0/24"
    name = "svil-xol"
  },
  {
    address_prefix = "192.168.2.0/24"
    name = "coll-xol"
  }
  ]
}