variable "vnet_name" {
  description = "The name of the virtual network."
  type        = string
}

variable "location" {
  description = "The Azure region for resources."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "The name of the AKS subnet."
  type        = string
}

variable "aks_subnet_prefixes" {
  description = "The address prefixes for the AKS subnet."
  type        = list(string)
}

variable "postgresql_subnet_name" {
  description = "The name of the PostgreSQL subnet."
  type        = string
}

variable "postgresql_subnet_prefixes" {
  description = "The address prefixes for the PostgreSQL subnet."
  type        = list(string)
}

variable "postgresql_nsg_name" {
  description = "The name of the NSG for the PostgreSQL subnet."
  type        = string
}

variable "aks_nsg_name" {
  description = "The name of the Network Security Group for the AKS subnet."
  type        = string
  default     = "aks-nsg"
}

