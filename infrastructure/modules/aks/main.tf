resource "azurerm_user_assigned_identity" "kubelet" {
  name                = "${var.cluster_name}-kubelet-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "${var.cluster_name}-aks-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
}


resource "azurerm_role_assignment" "kubelet_identity_operator" {
  principal_id          = azurerm_user_assigned_identity.aks_identity.principal_id
  role_definition_name  = "Managed Identity Operator"
  scope                 = azurerm_user_assigned_identity.kubelet.id
}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  kubelet_identity {
    client_id                 = azurerm_user_assigned_identity.kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.kubelet.principal_id
    user_assigned_identity_id = azurerm_user_assigned_identity.kubelet.id
  }

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size
    node_network_profile {
        allowed_host_ports {
            port_start = 5000
            port_end = 5000
            protocol = "TCP"
        }
    }
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = var.tags

  depends_on = [ azurerm_role_assignment.kubelet_identity_operator ]
}
