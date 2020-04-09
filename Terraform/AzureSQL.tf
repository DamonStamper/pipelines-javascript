resource "random_string" "randomsqlservername" {
  length = 16
  upper = false
  special = false
}

resource "random_string" "randomsqldbname" {
  length = 16
  upper = false
  special = false
}

resource "random_password" "randomsqlpassword" {
  length = 32
  special = true
}

resource "azurerm_sql_server" "SQLServer" {
  #name must be globally unique
  name                         = "sqlserver-${random_string.randomsqlservername.result}"
  resource_group_name          = azurerm_resource_group.RG.name
  location                     = azurerm_resource_group.RG.location
  version                      = "12.0"
  administrator_login          = "TheAdmin"
  administrator_login_password = random_password.randomsqlpassword.result
}

output "SQLPassword" {
  value = azurerm_sql_server.SQLServer.administrator_login_password
}

#Storage account defined in Storage.tf
#resource "azurerm_sql_database" "SQLDB" {
#  name                = "sqldb"
#  resource_group_name = azurerm_resource_group.RG.name
#  location            = azurerm_resource_group.RG.location
#  server_name         = azurerm_sql_server.SQLServer.name
#}

resource "azurerm_mssql_database" "SQLDB" {
  name           = "sqldb-${random_string.randomsqldbname.result}"
  server_id      = azurerm_sql_server.SQLServer.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  sku_name       = "GP_S_Gen5_1"
  min_capacity   = 1
  auto_pause_delay_in_minutes = 60
}