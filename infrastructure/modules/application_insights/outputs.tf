output "instrumentation_key" {
  description = "The Instrumentation Key of the Application Insights resource."
  value       = azurerm_application_insights.app_insights.instrumentation_key
}
