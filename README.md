# Azure Container App CI/CD Project

This repository contains the Terraform infrastructure and GitHub Actions pipeline for deploying a containerized Python application to **Azure Container Apps** with traffic splitting (Blue/Green or Canary) and monitoring.

---

## **Project Overview**

- **Container App Environment**: Managed environment for Azure Container Apps  
- **Container App**: Python app containerized with Docker  
- **Container Registry**: Azure Container Registry (ACR) to store Docker images  
- **Monitoring**: Log Analytics and Azure Monitor alerts for CPU, memory, and deployment failures  
- **CI/CD Pipeline**: GitHub Actions to lint, test, build, push, and deploy  

---
## **1️⃣ Deployment Instructions**

### **1. Terraform Infrastructure**
```bash
# Initialize Terraform
terraform init

# Apply Terraform plan
terraform apply -auto-approve

# Build Docker image
docker build -t containerregistry0011.azurecr.io/python-app:v1 .

# Log in to Azure Container Registry
az acr login --name containerregistry0011

# Push image to ACR
docker push <ACR_NAME>.azurecr.io/python-app:v1

az containerapp update \
  --name container-app \
  --resource-group RG-1 \
  --container-name demo \
  --image containerregistry0011.azurecr.io/python-app:v1

Rollback Steps

List revisions:

az containerapp revision list --name container-app --resource-group RG-1

Logs & Troubleshooting

Real-time container logs:

az containerapp logs show --name container-app --resource-group RG-1 --follow


CI/CD Pipeline (GitHub Actions)

Pipeline stages:

Lint + Unit tests
Build Docker image
Push image to ACR
Deploy to Azure Container App
Traffic shift for Blue/Green deployment

GitHub Secrets required:

AZURE_CLIENT_ID
AZURE_CLIENT_SECRET
AZURE_TENANT_ID
AZURE_SUBSCRIPTION_ID



Notes
Blue/Green deployment is implemented via revision traffic weights.
Terraform .terraform folder and provider binaries are ignored in GitHub.
Logs and monitoring are centralized in Azure Log Analytics.
Adjust revision traffic weights in YAML for automatic traffic splitting.



## Project Overview

This repository contains both:

1. **Terraform infrastructure code** (`terraform/`) to provision Azure resources:
   - Resource Group, Container App Environment, Container App
   - Azure Container Registry (ACR)
   - Log Analytics Workspace
   - Alerts and monitoring

2. **CI/CD pipeline configuration** via GitHub Actions (`.github/workflows/azure-containerapp.yml`):
   - Lint + Unit tests
   - Build Docker image
   - Push to ACR
   - Deploy to Azure Container App
   - Blue/Green traffic shift


#####  URL to browse
https://container-app.gentlepond-3fc0430c.eastus.azurecontainerapps.io
