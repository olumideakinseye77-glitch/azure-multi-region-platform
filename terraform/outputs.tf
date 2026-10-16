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
