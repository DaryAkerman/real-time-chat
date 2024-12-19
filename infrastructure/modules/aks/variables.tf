variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "The Azure region for resources."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group for the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix for the AKS cluster."
  type        = string
}

variable "node_count" {
  description = "The initial number of nodes in the AKS cluster."
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "The VM size for the AKS cluster nodes."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "subnet_id" {
  description = "The subnet ID to associate with the AKS cluster."
  type        = string
}

variable "tags" {
  description = "Tags to associate with the AKS cluster."
  type        = map(string)
  default     = {}
}

variable "max_node_count" {
  description = "The maximum number of nodes for autoscaling."
  type        = number
  default     = 5
}

variable "min_node_count" {
  description = "The minimum number of nodes for autoscaling."
  type        = number
  default     = 1
}

variable "service_cidr" {
  description = "The service CIDR for Kubernetes services."
  type        = string
  default     = "10.1.0.0/16"
}

variable "dns_service_ip" {
  description = "The DNS service IP for Kubernetes."
  type        = string
  default     = "10.1.0.10"
}