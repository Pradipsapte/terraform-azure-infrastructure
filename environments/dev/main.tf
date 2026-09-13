data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}


module "network" {
  source                = "../../modules/network"
  vnet_name             = var.vnet_name
  address_space         = var.vnet_address_space
  subnet_name           = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  tags = var.tags
}


module "nsg" {
  source              = "../../modules/network-security-group"
  nsg_name            = "nsg-dev"
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  subnet_id           = module.network.subnet_id

  tags = var.tags
}


module "vm" {
  source              = "../../modules/vm"
  vm_name             = var.vm_name
  vm_size             = var.vm_size
  location            = data.azurerm_resource_group.existing.location
  resource_group_name = data.azurerm_resource_group.existing.name
  subnet_id           = module.network.subnet_id
  admin_username      = var.admin_username
  ssh_public_key      = var.ssh_public_key
  tags                = var.tags
}
