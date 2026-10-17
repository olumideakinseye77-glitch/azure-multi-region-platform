resource "azurerm_monitor_metric_alert" "origin_health" {
  name                = "alert-olu-origin-health"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_cdn_frontdoor_profile.main.id]
  description         = "A Front Door origin has averaged below 90 percent health over five minutes."
  severity            = 2
  frequency           = "PT1M"
  window_size         = "PT5M"
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Cdn/profiles"
    metric_name      = "OriginHealthPercentage"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 90

    dimension {
      name     = "Origin"
      operator = "Include"
      values   = ["*"]
    }

    dimension {
      name     = "OriginGroup"
      operator = "Include"
      values   = ["*"]
    }
  }

  tags = azurerm_resource_group.main.tags
}
