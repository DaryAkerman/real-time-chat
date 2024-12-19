variable "release_name" {
  description = "The name of the Helm release."
  type        = string
}

variable "namespace" {
  description = "The Kubernetes namespace in which to install the Helm release."
  type        = string
}

variable "chart" {
  description = "The name of the Helm chart."
  type        = string
}

variable "repository" {
  description = "The Helm repository URL."
  type        = string
}

variable "chart_version" {
  description = "The version of the Helm chart."
  type        = string
}

variable "namespace_dependency" {
  description = "Dependency for the namespace to ensure it exists before installing the Helm chart."
  type        = any
}

variable "values_map" {
  description = "Map of values to pass to the Helm chart."
  type        = any
  default     = {}
}