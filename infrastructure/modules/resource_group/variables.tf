variable "name" {
  description = "The name of the Application Insights resource."
  type        = string
}

variable "location" {
  description = "The location of the Application Insights resource."
  type        = string
}

variable "tags" {
  description = "Tags to associate with the Application Insights resource."
  type        = map(string)
  default     = {}
}
