resource "azurerm_service_plan" "primary" {
  name                = "asp-olu-mr-uks"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.primary_location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Owner       = "Olu"
    RegionRole  = "Primary"
  }
}

resource "azurerm_service_plan" "secondary" {
  name                = "asp-olu-mr-ukw"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.secondary_location
  os_type             = "Linux"
  sku_name            = "B1"

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Owner       = "Olu"
    RegionRole  = "Secondary"
  }
}

resource "azurerm_linux_web_app" "primary" {
  name                                           = "app-olu-mr-uks-0be06fbd"
  resource_group_name                            = azurerm_resource_group.main.name
  location                                       = var.primary_location
  service_plan_id                                = azurerm_service_plan.primary.id
  https_only                                     = true
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false

  site_config {
    always_on        = true
    app_command_line = "gunicorn --bind=0.0.0.0:8000 --timeout 600 app:app"

    application_stack {
      python_version = "3.12"
    }
  }

  app_settings = {
    APP_REGION                     = "uksouth"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    REGION_NAME                    = "UK South"
    REGION_ROLE                    = "Primary"
    PROJECT_NAME                   = var.project_name
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Owner       = "Olu"
    RegionRole  = "Primary"
  }
}

resource "azurerm_linux_web_app" "secondary" {
  name                                           = "app-olu-mr-ukw-0be06fbd"
  resource_group_name                            = azurerm_resource_group.main.name
  location                                       = var.secondary_location
  service_plan_id                                = azurerm_service_plan.secondary.id
  https_only                                     = true
  ftp_publish_basic_authentication_enabled       = false
  webdeploy_publish_basic_authentication_enabled = false

  site_config {
    always_on        = true
    app_command_line = "gunicorn --bind=0.0.0.0:8000 --timeout 600 app:app"

    application_stack {
      python_version = "3.12"
    }
  }

  app_settings = {
    APP_REGION                     = "ukwest"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    REGION_NAME                    = "UK West"
    REGION_ROLE                    = "Secondary"
    PROJECT_NAME                   = var.project_name
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Owner       = "Olu"
    RegionRole  = "Secondary"
  }
}
