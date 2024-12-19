resource "azurerm_postgresql_flexible_server" "postgresql" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  administrator_login           = var.admin_username
  administrator_password        = var.admin_password
  sku_name                      = var.sku_name
  version                       = "13"
  storage_mb                    = var.storage_mb
  delegated_subnet_id           = var.delegated_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  tags                          = var.tags
  zone                          = "1"
  public_network_access_enabled = false
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.postgresql.id
  collation = "en_US.utf8"
  charset   = "utf8"
}
