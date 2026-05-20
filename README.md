# 🚀 Azure Web App — Terraform Demo
**Author:** Ramalakshmi Mani (Rama) | Senior Cloud & Platform Engineer @ BMW TechWorks

A hands-on Azure infrastructure demo using Terraform — showcasing real-world cloud engineering skills for portfolio and job applications in the Netherlands.

---

## 🏗️ What This Deploys

| Resource | Purpose |
|----------|---------|
| **Resource Group** | Logical container for all resources |
| **Virtual Network + Subnet** | Network isolation with App Service delegation |
| **Azure App Service Plan** | Hosting plan (Free tier for demo) |
| **Azure Linux Web App** | Python 3.11 web application |
| **Azure Key Vault** | Secure secrets management (DB string, API keys) |
| **System Managed Identity** | Passwordless access from App to Key Vault |
| **GitHub Source Control** | Auto deploy from GitHub repo |
| **Application Insights** | Monitoring & observability |

---

## 📁 Project Structure

```
azure-webapp-terraform/
├── main.tf                          # Root module — wires everything together
├── variables.tf                     # Input variables
├── locals.tf                        # Common tags and locals
├── outputs.tf                       # Output values
├── terraform.tfvars.example         # Example variable values
├── .gitignore                       # Ignores state files and secrets
└── modules/
    ├── networking/main.tf           # VNet + Subnet
    ├── keyvault/main.tf             # Key Vault + Secrets
    └── appservice/main.tf           # App Service + GitHub Deploy + Monitoring
```

---

## ⚡ Quick Start

### Prerequisites
- [Terraform >= 1.5.0](https://developer.hashicorp.com/terraform/install)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription (free tier works!)

### Steps

```bash
# 1. Login to Azure
az login

# 2. Clone this repo
git clone https://github.com/YOUR_USERNAME/azure-webapp-terraform
cd azure-webapp-terraform

# 3. Copy and edit variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values

# 4. Initialize Terraform
terraform init

# 5. Preview what will be created
terraform plan

# 6. Deploy!
terraform apply

# 7. Get your live URL
terraform output web_app_url
```

---

## 🔒 Security Highlights

- ✅ **No hardcoded secrets** — all secrets stored in Azure Key Vault
- ✅ **Managed Identity** — passwordless access between App and Key Vault
- ✅ **HTTPS only** enforced on Web App
- ✅ **VNet Integration** for network isolation
- ✅ **.gitignore** prevents state files and secrets from being committed

---

## 🧹 Cleanup

```bash
# Destroy all resources when done (avoids Azure charges)
terraform destroy
```

---

## 🌍 Why This Project?

As a Senior Cloud & Platform Engineer actively exploring opportunities in the Netherlands, this project demonstrates:
- Real-world Terraform module structure
- Azure best practices (Key Vault, Managed Identity, VNet)
- GitHub-connected CI/CD deployment
- Monitoring with Application Insights

---

## 📬 Connect

- 💼 [LinkedIn](https://linkedin.com/in/ramalakshmim)
- 📧 ramalakshmi0505@outlook.com
