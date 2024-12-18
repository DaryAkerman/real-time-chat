# Retrieve current Azure AD Client Config
data "azurerm_client_config" "current" {}

resource "kubernetes_manifest" "secret_provider_class" {
  manifest = {
    "apiVersion" = "secrets-store.csi.x-k8s.io/v1"
    "kind"       = "SecretProviderClass"
    "metadata" = {
      "name"      = "azure-kv-secrets"
      "namespace" = "default"
    }
    "spec" = {
      "provider" = "azure"
      "parameters" = {
        "useVMManagedIdentity" = "true"
        "userAssignedIdentityID" = var.user_assigned_identity_id
        "keyvaultName"   = var.keyvault_name
        "tenantId"       = var.tenant_id
        "objects" = <<-EOT
          array:
            - |
              objectName: POSTGRESQL-URI
              objectType: secret
              objectVersion: ""
            - |
              objectName: SECRET-KEY
              objectType: secret
              objectVersion: ""
            - |
              objectName: INSTRUMENTATION-KEY
              objectType: secret
              objectVersion: ""
        EOT
      }
      "secretObjects" = [
        {
          "secretName" = "postgresql-uri"
          "type"       = "Opaque"
          "data" = [
            {
              "objectName" = "POSTGRESQL-URI"
              "key"        = "POSTGRESQL-URI"
            }
          ]
        },
        {
          "secretName" = "secret-key"
          "type"       = "Opaque"
          "data" = [
            {
              "objectName" = "SECRET-KEY"
              "key"        = "SECRET-KEY"
            }
          ]
        },
        {
          "secretName" = "instrumentation-key"
          "type"       = "Opaque"
          "data" = [
            {
              "objectName" = "INSTRUMENTATION-KEY"
              "key"        = "INSTRUMENTATION-KEY"
            }
          ]
        }
      ]
    }
  }
}