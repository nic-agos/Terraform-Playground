variable "indexes" {
  type = list(number)
  description = "storage indexes"
  default = [1, 2, 3, 4, 5]
}

variable "stgaccts" {
  type = map(object({
    name     = string
    location = string
    kind     = string
    repl     = string
    tier     = string
  }))
 
  default = {
    "sa1" = {
      name     = "jbttfdemowestus3"
      location = "WestUS3"
      kind     = "StorageV2"
      repl     = "LRS"
      tier     = "Standard"
    },
 
    "sa2" = {
      name     = "jbttfdemoeastus"
      location = "EastUS"
      kind     = "StorageV2"
      repl     = "GRS"
      tier     = "Standard"
    }
  }
}