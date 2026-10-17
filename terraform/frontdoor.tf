resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = "afd-olu-multi-region"
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "Standard_AzureFrontDoor"
}

resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                     = "afd-olu-mr-0be06fbd"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
}

resource "azurerm_cdn_frontdoor_origin_group" "main" {
  name                     = "regional-apps"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled = false

  load_balancing {
    sample_size                        = 4
    successful_samples_required        = 3
    additional_latency_in_milliseconds = 100
  }

  health_probe {
    path                = "/health"
    protocol            = "Https"
    request_type        = "GET"
    interval_in_seconds = 30
  }
}

resource "azurerm_cdn_frontdoor_origin" "apps" {
  for_each = {
    uksouth = azurerm_linux_web_app.primary.default_hostname
    ukwest  = azurerm_linux_web_app.secondary.default_hostname
  }

  name                           = each.key
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.main.id
  enabled                        = true
  host_name                      = each.value
  origin_host_header             = each.value
  http_port                      = 80
  https_port                     = 443
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "main" {
  name                          = "app-route"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.main.id
  cdn_frontdoor_origin_ids = [
    for origin in azurerm_cdn_frontdoor_origin.apps : origin.id
  ]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  link_to_default_domain = true
}

output "frontdoor_url" {
  value = "https://${azurerm_cdn_frontdoor_endpoint.main.host_name}"
}
