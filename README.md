# Azure Terraform Infrastructure

This repository contains Terraform scripts to deploy an Azure infrastructure with the following components:

- Resource Group
- Virtual Network
- Subnets
- Public IP
- Network Interface
- Linux Virtual Machine (private access)
- Bastion Host
- Application Gateway (Public access)

## Prerequisites

Before you begin, ensure you have the following:

- [Terraform](https://www.terraform.io/downloads.html) installed
- Azure subscription and necessary permissions
- SP account should have storage account permisssion as terraform statefile is storing in Azure storage
   ```bash
   az role assignment create \
     --role "Storage Blob Data Contributor" \
     --assignee "<clientId>" \
     --scope "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/Microsoft.Storage/storageAccount

## Usage

1. **GoTo Github action**

- Update Secrets and subscription ID if required
- Trigger the pipeline in Github action
- Once the pipeline completed successfully we can get Application Gateway public IP from pipeline console log to access the Docker image py flash page
- web access procedure 
    https://public IP:5000
