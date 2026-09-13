terraform {

  backend "azurerm" {
    resource_group_name  = "kml_rg_main-b5bccf2caec24e92"
    storage_account_name = "devstorageaccount1994"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  use_oidc                        = true
}
