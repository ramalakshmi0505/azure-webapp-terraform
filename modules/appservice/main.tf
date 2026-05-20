###############################################################
# Module: App Service
# Creates App Service Plan + Web App + GitHub Deploy + Monitoring
###############################################################

variable "resource_group_name" {}
variable "location"            {}
variable "project_name"        {}
variable "environment"         {}
variable "suffix"              {}
variable "keyvault_id"         {}
variable "tags"                {}

# ─────────────────────────────────────────────
# App Service Plan (Free tier for demo)
# ─────────────────────────────────────────────
resource "azurerm_service_plan" "main" {
  name                = "${var.project_name}-plan-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = "F1"  # Free tier — perfect for demo
  tags                = var.tags
}

# ─────────────────────────────────────────────
# Linux Web App
# ─────────────────────────────────────────────
resource "azurerm_linux_web_app" "main" {
  name                = "${var.project_name}-app-${var.suffix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true

  identity {
    type = "SystemAssigned"
  }

  site_config {
    always_on = false  # Must be false for Free tier

    application_stack {
      python_version = "3.11"
    }
  }

  app_settings = {
    "ENVIRONMENT"                    = var.environment
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "SCM_DO_BUILD_DURING_DEPLOYMENT" = "true"
    # Reference Key Vault secrets securely
    "DB_CONNECTION_STRING" = "@Microsoft.KeyVault(SecretUri=${var.keyvault_id}/secrets/db-connection-string/)"
    "APP_API_KEY"          = "@Microsoft.KeyVault(SecretUri=${var.keyvault_id}/secrets/app-api-key/)"
  }

  logs {
    application_logs {
      file_system_level = "Information"
    }
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }

  tags = var.tags
}

# ─────────────────────────────────────────────
# Key Vault Access Policy for Web App Identity
# ─────────────────────────────────────────────
resource "azurerm_key_vault_access_policy" "app" {
  key_vault_id = var.keyvault_id
  tenant_id    = azurerm_linux_web_app.main.identity[0].tenant_id
  object_id    = azurerm_linux_web_app.main.identity[0].principal_id

  secret_permissions = ["Get", "List"]
}

# ─────────────────────────────────────────────
# GitHub Deployment (Source Control)
# ─────────────────────────────────────────────
resource "azurerm_app_service_source_control" "github" {
  app_id                 = azurerm_linux_web_app.main.id
  repo_url               = "https://github.com/YOUR_USERNAME/YOUR_REPO"
  branch                 = "main"
  use_manual_integration = true
}

# ─────────────────────────────────────────────
# Application Insights (Monitoring)
# ─────────────────────────────────────────────
resource "azurerm_application_insights" "main" {
  name                = "${var.project_name}-appinsights-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  tags                = var.tags
}

output "web_app_name"     { value = azurerm_linux_web_app.main.name }
output "web_app_hostname" { value = azurerm_linux_web_app.main.default_hostname }
output "web_app_id"       { value = azurerm_linux_web_app.main.id }
output "app_insights_key" { value = azurerm_application_insights.main.instrumentation_key }
