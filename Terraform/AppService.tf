resource "random_uuid" "RandomUISuffix" { }

resource "random_uuid" "RandomAPISuffix" { }

resource "azurerm_app_service_plan" "ASP" {
  name                = "appserviceplan"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "ASUI" {
  name                = "app-service-ui-${random_uuid.RandomUISuffix.result}"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  app_service_plan_id = azurerm_app_service_plan.ASP.id
  
  app_settings = {
    "APIURL" = "${azurerm_app_service.ASAPI.default_site_hostname}"
    #" VSCode's TF highlighting is being wonky so this gets rid of that.
  }
}

resource "azurerm_app_service" "ASAPI" {
  name                = "app-service-api-${random_uuid.RandomAPISuffix.result}"
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  app_service_plan_id = azurerm_app_service_plan.ASP.id

  connection_string {
    name  = "Database"
    type  = "SQLServer"
    value = "Server=${azurerm_sql_server.SQLServer.fully_qualified_domain_name};Integrated Security=SSPI"
    #" VSCode's TF highlighting is being wonk so this gets rid of that.
  }
}

