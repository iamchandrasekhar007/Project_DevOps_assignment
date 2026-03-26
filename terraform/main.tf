resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.loc_name
}

resource "azurerm_log_analytics_workspace" "logs" {
  name                = var.law_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  depends_on = [ azurerm_resource_group.rg ]
}
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "container-app-cpu-alert"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_container_app.app.id]
  description         = "Alert when CPU exceeds 80%"
  severity            = 3
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.App/containerApps"
    metric_name      = "CpuUsage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }
}

resource "azurerm_monitor_metric_alert" "memory_alert" {
  name                = "container-app-memory-alert"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [azurerm_container_app.app.id]
  description         = "Alert when memory exceeds 75%"
  severity            = 3
  frequency           = "PT1M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.App/containerApps"
    metric_name      = "MemoryUsage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 75
  }
}

resource "azurerm_container_registry" "acr" {
  name                = var.container_registry_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
  depends_on = [ azurerm_log_analytics_workspace.logs ]
}

resource "azurerm_container_app_environment" "env" {
  name                       = var.env_name
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id
  depends_on = [ azurerm_container_registry.acr ]
}

resource "azurerm_container_app" "app" {
  name                         = var.containerapp_name
  container_app_environment_id = azurerm_container_app_environment.env.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Multiple"

  template {
    container {
      name   = "demo"
      image  = "containerregistry0011.azurecr.io/python-app:v1"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
  revision_name = "container-app--0000002"
  percentage    = 50
}

traffic_weight {
  latest_name = "container-app--0000003"
  percentage    = 50
}
  }
  depends_on = [ azurerm_container_app_environment.env ]
}

