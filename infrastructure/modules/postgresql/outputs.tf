output "postgresql_hostname" {
  description = "The hostname of the PostgreSQL server."
  value       = azurerm_postgresql_flexible_server.postgresql.fqdn
}

output "admin_username" {
  description = "The administrator username for PostgreSQL."
  value       = azurerm_postgresql_flexible_server.postgresql.administrator_login
}

output "admin_password" {
  description = "The administrator password for PostgreSQL."
  value       = azurerm_postgresql_flexible_server.postgresql.administrator_password
}

output "database_name" {
  description = "The name of the created database."
  value       = azurerm_postgresql_flexible_server_database.db.name
}