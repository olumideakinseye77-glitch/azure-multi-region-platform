resource "azurerm_resource_group" "main" {
  name     = "rg-olu-multi-region-platform"
  location = var.primary_location

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Owner       = "Olu"
  }
}
