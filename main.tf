terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "4.66.0"
    }
  }
}

provider "aurerm" {
features{}  
}

resource "azurerm_resource_group" "rg-name" {
  name = "rg-name-1"
  location = "West Europe"
}

resource "azurerm_storage_account" "st-account-name" {
  name = "storage-account-name"
  resource_group_name = azurerm_resource_group.rg-name
  location = azurerm_resource_group.rg-name.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}