resource "azurerm_key_vault_secret" "keyvault_secret" {
  for_each      = var.secrets
  name          = each.key
  value         = each.value
  key_vault_id  = var.keyvault_id
}
