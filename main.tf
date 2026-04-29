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
  account_replication_type = "GZRS"
}



resource "azurerm_network_interface" "main" {
  name                = "network-interface"
  location            = azurerm_resource_group.rg-name.location
  resource_group_name = azurerm_resource_group.rg-name.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}



resource "azurerm_virtual_machine" "Virtual_machine_name" {
  name = "VM-1"
  resource_group_name = azurerm_resource_group.rg-name.name
  location = azurerm_resource_group.rg-name.location
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"  


  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}