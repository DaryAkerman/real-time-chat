variable "cluster_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "dns_prefix" {}
variable "node_count" { default = 2 }
variable "vm_size" { default = "Standard_DS2_v2" }
variable "tags" { type = map(string) }
