variable "admin_password" {
    description     = "The password for the database admin user"
    type            = string
    sensitive       = true
}

variable "admin_username" {
    description     = "The username for the database admin user"
    type            = string
}

variable "secret_key" {
    description     = "Flask secret app key"
    type            = string 
    sensitive       = true
}

variable "namespace" {
    description     = "The namespace for the environment in AKS"
    type        = string
}