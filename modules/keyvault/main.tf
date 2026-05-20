###############################################################
# Module: Key Vault
# Creates Azure Key Vault + stores demo secrets
###############################################################

variable "resource_group_name" {}
variable "location"            {}
variable "project_name"        {}
variable "environment"         {}
variable "suffix"              {}
variable "tags"                {}

data "azurerm_client_config" "current" {}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                        = "${var.project_name}-kv-${var.suffix}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  # Allow current user/SP full access
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update",
    ]
    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge",
    ]
    certificate_permissions = [
      "Get", "List",
    ]
  }

  tags = var.tags
}

# Demo Secret — App DB Connection String
resource "azurerm_key_vault_secret" "db_connection" {
  name         = "db-connection-string"
  value        = "Server=myserver.database.windows.net;Database=mydb;User=admin;"
  key_vault_id = azurerm_key_vault.main.id
  tags         = var.tags
}

# Demo Secret — API Key
resource "azurerm_key_vault_secret" "api_key" {
  name         = "app-api-key"
  value        = "demo-api-key-${var.suffix}"
  key_vault_id = azurerm_key_vault.main.id
  tags         = var.tags
}

# Demo Secret — App Secret
resource "azurerm_key_vault_secret" "app_secret" {
  name         = "app-secret"
  value        = "my-super-secret-demo-value"
  key_vault_id = azurerm_key_vault.main.id
  tags         = var.tags
}

output "keyvault_id"   { value = azurerm_key_vault.main.id }
output "keyvault_name" { value = azurerm_key_vault.main.name }
output "keyvault_uri"  { value = azurerm_key_vault.main.vault_uri }
