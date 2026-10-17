resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-olu-multi-region"
  location            = var.primary_location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 0.1

  tags = azurerm_resource_group.main.tags
}

resource "azurerm_monitor_diagnostic_setting" "frontdoor" {
  name                       = "frontdoor-to-log-analytics"
  target_resource_id         = azurerm_cdn_frontdoor_profile.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "FrontDoorAccessLog"
  }

  enabled_log {
    category = "FrontDoorHealthProbeLog"
  }
}
