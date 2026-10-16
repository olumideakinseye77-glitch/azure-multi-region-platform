variable "subscription_id" {
  description = "Azure subscription ID."
  type        = string
}

variable "primary_location" {
  description = "Primary Azure region."
  type        = string
  default     = "UK South"
}

variable "secondary_location" {
  description = "Secondary Azure region."
  type        = string
  default     = "UK West"
}

variable "environment" {
  description = "Environment tag."
  type        = string
  default     = "lab"
}

variable "project_name" {
  description = "Project tag."
  type        = string
  default     = "multi-region-platform"
}
