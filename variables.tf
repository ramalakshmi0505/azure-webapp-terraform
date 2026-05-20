###############################################################
# Variables
###############################################################

variable "project_name" {
  description = "Project name used as prefix for all resources"
  type        = string
  default     = "rama-azure-demo"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "westeurope"
}

variable "github_repo_url" {
  description = "GitHub repo URL for App Service deployment"
  type        = string
  default     = "https://github.com/YOUR_USERNAME/YOUR_REPO"
}

variable "github_branch" {
  description = "GitHub branch to deploy from"
  type        = string
  default     = "main"
}

variable "app_secret_value" {
  description = "Demo secret value stored in Key Vault"
  type        = string
  sensitive   = true
  default     = "my-super-secret-demo-value"
}
