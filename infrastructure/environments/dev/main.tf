module "resource_group" {
  source   = "../../modules/resource_group"
  name     = "real-time-chat-rg-dev"
  location = "Canada Central"
  tags = {
    environment = "dev"
    project     = "real-time-chat"
  }
}

module "application_insights" {
  source              = "../../modules/application_insights"
  name                = "real-time-app-insights-dev"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags = {
    environment = "dev"
    project     = "real-time-chat"
  }
}

module "postgresql" {
  source              = "../../modules/postgresql"
  name                = "real-time-chat-db-dev-darytest"
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  admin_username      = "dbadmin"
  admin_password      = var.admin_password
  database_name       = "real_time_chat_db"
  tags = {
    environment = "dev"
    project     = "real-time-chat"
  }
}