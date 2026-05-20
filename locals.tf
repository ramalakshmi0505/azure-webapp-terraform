###############################################################
# Locals
###############################################################

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Ramalakshmi Mani"
    Purpose     = "Azure Hands-on Demo"
  }
}
