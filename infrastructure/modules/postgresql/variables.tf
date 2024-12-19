variable "name" {
  description = "The name of the PostgreSQL server."
  type        = string
}

variable "location" {
  description = "The location/region of the PostgreSQL server."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for the PostgreSQL server."
  type        = string
}

variable "admin_username" {
  description = "Administrator username for PostgreSQL."
  type        = string
}

variable "admin_password" {
  description = "Administrator password for PostgreSQL."
  type        = string
}

variable "sku_name" {
  description = "The SKU tier for the PostgreSQL server."
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  description = "The storage size for the PostgreSQL server in MB."
  type        = number
  default     = 32768
}

variable "database_name" {
  description = "The name of the database to create."
  type        = string
}

variable "tags" {
  description = "Tags to associate with the PostgreSQL server."
  type        = map(string)
  default     = {}
}

variable "delegated_subnet_id" {
  description = "The ID of the delegated subnet for PostgreSQL."
  type        = string
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone for PostgreSQL."
  type        = string
}
