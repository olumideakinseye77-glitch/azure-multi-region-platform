output "resource_group_name" {
  description = "Project resource group name."
  value       = azurerm_resource_group.main.name
}

output "primary_location" {
  description = "Primary Azure region."
  value       = var.primary_location
}

output "secondary_location" {
  description = "Secondary Azure region."
  value       = var.secondary_location
}

output "primary_app_hostname" {
  description = "UK South App Service hostname."
  value       = azurerm_linux_web_app.primary.default_hostname
}

output "secondary_app_hostname" {
  description = "UK West App Service hostname."
  value       = azurerm_linux_web_app.secondary.default_hostname
}
