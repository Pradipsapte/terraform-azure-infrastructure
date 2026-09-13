resource_group_name   = "kml_rg_main-b5bccf2caec24e92"
vnet_name             = "vnet-dev"
vnet_address_space    = ["10.1.0.0/16"]
subnet_name           = "subnet-dev"
subnet_address_prefix = ["10.1.0.0/24"]
vm_name               = "vm-dev"
vm_size               = "Standard_B1s"
admin_username        = "azureuser"
tags = {
  Environment = "Dev"
  Project     = "Terraform-Azure"
  ManagedBy   = "Terraform"
}
