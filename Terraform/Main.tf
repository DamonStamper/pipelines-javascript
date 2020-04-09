variable "subscription" {
  type    = string
}

variable "tenant" {
  type    = string
}

provider "azurerm" {
    version = "~>2.5.0"
    features {}
    subscription_id = var.subscription
    tenant_id       = var.tenant
}

resource "azurerm_resource_group" "RG" {
  name     = "RG"
  location = "East US 2"
}