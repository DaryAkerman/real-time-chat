output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}

output "postgresql_subnet_id" {
  value = azurerm_subnet.postgresql_subnet.id
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgresql.id
}

output "aks_nsg_id" {
  value = azurerm_network_security_group.aks_nsg.id
}
