name_xol                  = "RG-XOL-COLL"
existing_rg_name          = "VNET-AUTOMATION"
vnet_name                 = "VNET-AUTOMATION"
subnet_address_space      = ["10.1.0.0/24"]
pip_hostname              = ""
cache_name                = "txolbercache01azne"
cache_capacity            = 1
cache_family              = "C"
cache_sku_name            = "Basic"
cache_enable_non_ssl_port = false
cache_minimum_tls_version = "1.2"
pvt_end_sku               = "Standard"
is_manual_connection      = false
tags = {
  "Scope" = "Terraform"
}