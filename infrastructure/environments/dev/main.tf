
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

module "network" {
  source                  = "../../modules/network"
  vnet_name               = "vnet"
  location                = module.resource_group.location
  resource_group_name     = module.resource_group.name
  address_space           = ["10.0.0.0/16"]
  aks_subnet_name         = "aks-subnet"
  aks_subnet_prefixes     = ["10.0.1.0/24"]
  postgresql_subnet_name  = "postgresql-subnet"
  postgresql_subnet_prefixes = ["10.0.2.0/24"]
  postgresql_nsg_name     = "postgresql-nsg"
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
  source                  = "../../modules/postgresql"
  name                    = "real-time-chat-db-dev-darytest"
  location                = module.resource_group.location
  resource_group_name     = module.resource_group.name
  admin_username          = var.admin_username
  admin_password          = var.admin_password
  database_name           = "real_time_chat_db"
  tags = {
    environment           = var.namespace
    project               = "real-time-chat"
  }
  delegated_subnet_id     = module.network.postgresql_subnet_id
  private_dns_zone_id     = module.network.private_dns_zone_id
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
  subnet_id           = module.network.aks_subnet_id
  min_node_count      = 1
  max_node_count      = 5
}

# Key Vault Module
module "keyvault" {
  source                     = "../../modules/keyvault"
  keyvault_name              = "MyKeyVaultdaryakerrss"
  location                   = module.resource_group.location
  resource_group_name        = module.resource_group.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  object_id                  = module.aks.aks_identity_object_id
  kubelet_object_id          = module.aks.kubelet_identity_object_id
}

module "dev_namespace" {
  source          = "../../modules/namespace"
  namespace_name  = "dev"
}

# Secret Provider Class module
module "secret_provider_class" {
  source                    = "../../modules/secret_provider_class"
  keyvault_name             = module.keyvault.keyvault_name
  tenant_id                 = data.azurerm_client_config.current.tenant_id
  user_assigned_identity_id = module.aks.kubelet_identity_id
  namespace                 = "dev" 
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

module "argocd_namespace" {
  source          = "../../modules/namespace"
  namespace_name  = "argocd"
}

module "argocd_helm" {
  source               = "../../modules/helm"
  release_name         = "argocd"
  namespace            = module.argocd_namespace.namespace_name
  chart                = "argo-cd"
  repository           = "https://argoproj.github.io/argo-helm"
  chart_version        = "5.18.1"
  namespace_dependency = module.argocd_namespace
  values_map           = yamldecode(file("${path.module}/helm-values/argo-values.yaml"))
}
