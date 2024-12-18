
data "azurerm_client_config" "current" {}

# Resource Group Module
module "resource_group" {
  source   = "../../modules/resource_group"
  name     = "real-time-chat-rg-dev"
  location = "canadacentral"
  tags = {
    environment = var.namespace
    project     = "real-time-chat"
  }
}

# Application Insights Module
module "application_insights" {
  source              = "../../modules/application_insights"
  name                = "real-time-app-insights-dev"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags = {
    environment = var.namespace
    project     = "real-time-chat"
  }
}

# PostgreSQL Module
module "postgresql" {
  source              = "../../modules/postgresql"
  name                = "real-time-chat-db-dev-darytest"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  database_name       = "real_time_chat_db"
  tags = {
    environment = var.namespace
    project     = "real-time-chat"
  }
}

# AKS Module
module "aks" {
  source              = "../../modules/aks"
  cluster_name        = "chatClusterr"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  dns_prefix          = "myAKS"
  node_count          = 3
  vm_size             = "Standard_DS2_v2"
  tags                = { Environment = "Dev" }
}

# Key Vault Module
module "keyvault" {
  source                     = "../../modules/keyvault"
  keyvault_name              = "MyKeyVaultdaryakerrr"
  location                   = module.resource_group.location
  resource_group_name        = module.resource_group.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  object_id                  = module.aks.aks_identity_object_id
  kubelet_object_id          = module.aks.kubelet_identity_object_id
}

# Secret Provider Class module
module "secret_provider_class" {
  source                    = "../../modules/secret_provider_class"
  keyvault_name             = module.keyvault.keyvault_name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  user_assigned_identity_id = module.aks.kubelet_identity_id
}

module "secrets" {
  source      = "../../modules/secrets"
  secrets = {
    POSTGRESQL-URI      = module.postgresql.postgresql_connection.connection_string
    SECRET-KEY          = var.secret_key
    INSTRUMENTATION-KEY = module.application_insights.instrumentation_key
  }
  keyvault_id = module.keyvault.keyvault_id
}
