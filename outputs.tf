###############################################################
# Outputs
###############################################################

output "resource_group_name" {
  description = "Name of the Resource Group"
  value       = azurerm_resource_group.main.name
}

output "web_app_url" {
  description = "Live URL of the deployed Web App"
  value       = "https://${module.appservice.web_app_hostname}"
}

output "web_app_name" {
  description = "Name of the Azure Web App"
  value       = module.appservice.web_app_name
}

output "keyvault_name" {
  description = "Name of the Azure Key Vault"
  value       = module.keyvault.keyvault_name
}

output "keyvault_uri" {
  description = "URI of the Azure Key Vault"
  value       = module.keyvault.keyvault_uri
}
