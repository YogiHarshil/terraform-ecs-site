# Azure Container Apps Module Outputs

# Application URLs
output "application_url" {
  description = "Application URL"
  value       = "https://${azurerm_container_app.main.latest_revision_fqdn}"
}

output "health_check_url" {
  description = "Health check endpoint URL"
  value       = "https://${azurerm_container_app.main.latest_revision_fqdn}${var.health_check_path}"
}

# Azure Resources
output "container_registry_url" {
  description = "Container registry URL"
  value       = azurerm_container_registry.main.login_server
}

output "container_app_name" {
  description = "Container app name"
  value       = azurerm_container_app.main.name
}

output "container_app_environment_name" {
  description = "Container app environment name"
  value       = azurerm_container_app_environment.main.name
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

# Monitoring
output "log_analytics_workspace_name" {
  description = "Log Analytics workspace name"
  value       = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  value       = azurerm_log_analytics_workspace.main.id
}

# Container Registry Credentials
output "container_registry_admin_username" {
  description = "Container registry admin username"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "container_registry_admin_password" {
  description = "Container registry admin password"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
} 