output "kubelet_identity_object_id" {
  value       = azurerm_user_assigned_identity.kubelet.principal_id
  description = "The Object ID of the Kubelet Managed Identity for the AKS cluster."
}

output "kubelet_identity_id" {
  value       = azurerm_user_assigned_identity.kubelet.client_id
  description = "The Object ID of the Kubelet Managed Identity for the AKS cluster."
}

output "aks_identity_object_id" {
  value       = azurerm_user_assigned_identity.aks_identity.principal_id
  description = "The Object ID of the AKS Managed Identity for the AKS cluster."
}

output "kube_config" {
  value = {
    host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
    client_certificate     = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
    client_key             = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
    cluster_ca_certificate = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
  }
  sensitive = true
}

output "cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
  description = "The name of the AKS cluster."
}

output "subnet_id" {
  description = "The subnet ID used by the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.default_node_pool[0].vnet_subnet_id
}

