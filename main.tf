###############################################################
# Azure Web App Demo - Terraform
# Author : Ramalakshmi Mani (Rama)
# Purpose: Hands-on Azure demo for LinkedIn portfolio
# Stack  : App Service + Key Vault + GitHub Deploy + Monitoring
###############################################################

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# Random suffix to ensure unique resource names
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# ─────────────────────────────────────────────
# Resource Group
# ─────────────────────────────────────────────
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-rg-${var.environment}"
  location = var.location

  tags = local.common_tags
}

# ─────────────────────────────────────────────
# Modules
# ─────────────────────────────────────────────
module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = var.project_name
  environment         = var.environment
  tags                = local.common_tags
}

module "keyvault" {
  source              = "./modules/keyvault"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = var.project_name
  environment         = var.environment
  suffix              = random_string.suffix.result
  tags                = local.common_tags
}

module "appservice" {
  source              = "./modules/appservice"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  project_name        = var.project_name
  environment         = var.environment
  suffix              = random_string.suffix.result
  keyvault_id         = module.keyvault.keyvault_id
  tags                = local.common_tags
}
