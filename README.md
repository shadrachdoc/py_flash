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

# Github Action Pipeline Stages

## 1. Checkout Repository

- Retrieve the source code from the version control system.

## 2. Build Docker Image

- Compile and package the application into a Docker image for seamless deployment.

## 3. Log in to Docker Hub

- Authenticate with Docker Hub to enable image push and pull operations.

## 4. Push Docker Image

- Upload the Docker image to the designated repository on Docker Hub for distribution.

## 5. Scan for Vulnerabilities

- Conduct a security scan on the Docker image to identify and address potential vulnerabilities.

## 6. Login to Azure Cloud

- Authenticate with the Azure Cloud platform to facilitate resource provisioning.

## 7. Set up Terraform

- Configure the Terraform infrastructure-as-code tool for managing and provisioning Azure resources.

## 8. Authenticate Using Service Principal

- Establish secure access using a Service Principal to execute Terraform code.

## 9. Terraform Init

- Initialize the Terraform environment, ensuring all necessary modules and providers are configured.

## 10. Terraform Apply

- Execute Terraform apply to deploy the infrastructure defined in code.
  

## 11. Post-Scan for Vulnerabilities

- Conduct a final security scan to validate the integrity of deployed resources.

# Future Enhancements

While the current implementation has been completed in a straightforward manner, there are opportunities for further improvements to enhance code reusability and deployment flexibility. The following future enhancements are suggested:

## 1. Terraform Module Integration

- Consider refactoring the codebase to leverage Terraform modules. This approach would not only enhance code reusability but also contribute to a more modular and maintainable infrastructure.

## 2. Terragrunt Implementation

- Explore the integration of Terragrunt, a tool that simplifies Terraform configuration management. This addition would improve the scalability and manageability of our infrastructure code.

## 3. Terratest Integration

- Implement Terratest to automate testing processes, ensuring the reliability of our infrastructure code. This step would contribute to a more robust and stable deployment pipeline.

These enhancements collectively aim to improve the code mobility, making it more adaptable to various environments, including TEST, UAT, Non-Prod, and Prod. 

