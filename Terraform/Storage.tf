resource "random_string" "randomstorageaccountname" {
  length  = 15
  #setting upper to false doesn't seem to do anything...
  upper   = false
  lower   = true
  number  = true
  special = false

}


resource "random_string" "randomstoragecontainername" {
  length  = 16
  #setting upper to false doesn't seem to do anything...
  upper   = false
  lower   = true
  number  = true
  special = false
}

resource "azurerm_storage_account" "StorageAccount" {
  #name is max 23 characters
  name                     = "strgacct${lower(random_string.randomstorageaccountname.result)}"
  resource_group_name      = azurerm_resource_group.RG.name
  location                 = azurerm_resource_group.RG.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "StorageContainer" {
  #name is max 23 characters
  name                  = "strgcntr-${lower(random_string.randomstoragecontainername.result)}"
  storage_account_name  = azurerm_storage_account.StorageAccount.name
  container_access_type = "private"
}