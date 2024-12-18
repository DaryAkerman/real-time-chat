output "resource_group_name" {
  description   = "The resource group name."
  value         = module.resource_group.name
}

output "instrumentation_key" {
  description   = "The Instrumentation key for the application."
  value         = module.application_insights.instrumentation_key
  sensitive     = true
}

output "postgresql_connection" {
  description   = "The PostgreSQL connection string for the application."
  value         = "postgresql://${module.postgresql.admin_username}:${module.postgresql.admin_password}@${module.postgresql.postgresql_hostname}/${module.postgresql.database_name}"  
  sensitive     = true
}

output "kube_config" {
  value         = module.aks.kube_config
  sensitive     = true
}
