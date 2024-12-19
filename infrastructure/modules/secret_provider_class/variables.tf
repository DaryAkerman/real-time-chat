variable "keyvault_name" {
  description = "The name of the Azure Key Vault."
  type        = string
}

variable "tenant_id" {
  description = "The Azure tenant ID."
  type        = string
}

variable "user_assigned_identity_id" {
  description = "The User Assigned Identity ID."
  type        = string
}

variable "namespace" {
  type = string
}