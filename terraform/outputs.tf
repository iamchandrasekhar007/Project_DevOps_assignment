output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "container_registry_name" {
  value = azurerm_container_registry.acr.name
}

output "container_registry_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.logs.name
}

output "container_app_url" {
  value = azurerm_container_app.app.latest_revision_fqdn
}