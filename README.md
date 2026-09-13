# Azure Infrastructure Automation with Terraform

This project demonstrates how to provision and manage Azure infrastructure using **Terraform** within an existing Azure Resource Group.

The project uses reusable Terraform modules and a dedicated **Dev environment**. Terraform state is stored remotely in an Azure Storage Account, and GitHub Actions is used for CI/CD with **OIDC-based authentication** to Azure.

## Architecture

```text
                         GitHub Repository
                                |
                                v
                     GitHub Actions Workflow
                                |
                         OIDC Authentication
                                |
                                v
                       Microsoft Entra ID
                         App Registration
                                |
                                v
                            Azure
                                |
                     Existing Resource Group
                                |
        +-----------------------+-----------------------+
        |                       |                       |
        v                       v                       v
      VNet                     NSG               Storage Account
        |                                               |
      Subnet                                      Terraform State
        |
        v
       VM(s)
```

## Project Structure

```text
terraform-azure-infra/
│
├── environments/
│   └── dev/
│       ├── backend.tf
│       ├── provider.tf
│       ├── versions.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
│
├── modules/
│   ├── network/
│   ├── network-security-group/
│   ├── storage/
│   └── vm/
│
├── .github/
│   └── workflows/
│       └── terraform.yml
│
├── .gitignore
└── README.md
```

## Azure Resources

The project manages Azure infrastructure inside an **existing Resource Group**.

Resources managed by Terraform include:

* Azure Virtual Network
* Subnets
* Network Security Groups
* Storage Account
* Azure Virtual Machines
* Network interfaces
* Public IP resources where required

The Resource Group itself is **not created by Terraform**.

## Existing Resource Group

The project uses an existing Azure Resource Group as the deployment scope.

```text
Existing Azure Resource Group
            |
            +-- Virtual Network
            |
            +-- Subnet
            |
            +-- Network Security Group
            |
            +-- Storage Account
            |
            +-- Virtual Machine
            |
            +-- Network Interface
            |
            +-- Public IP
```

Terraform references the existing Resource Group instead of creating a new one.

For example:

```hcl
data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}
```

Resources can then use the existing Resource Group:

```hcl
resource_group_name = data.azurerm_resource_group.existing.name
```

This approach is useful when the Azure subscription has restrictions that prevent Terraform from creating or managing Resource Groups.

## Terraform Modules

### Network

Creates the networking foundation:

* Virtual Network
* Subnets

### Network Security Group

Manages network access rules and associates NSGs with the required subnet or network interface.

### Storage

Creates the Azure Storage Account and related resources used by the project.

The Storage Account is also used for the remote Terraform backend.

### VM

Creates and configures Azure Virtual Machine infrastructure together with the required networking components.

## Environment

The project currently contains a single **Dev environment**:

```text
environments/
└── dev/
```

The environment-specific configuration references the existing Resource Group and passes the required values to the reusable Terraform modules.

## Remote Terraform State

Terraform state is stored remotely in an **Azure Storage Account** using the AzureRM backend.

```text
Terraform
    |
    v
Azure Storage Account
    |
    └── Blob Container
            |
            └── Dev Terraform State
```

Remote state provides a centralized location for Terraform state and prevents the Terraform state file from being committed to Git.

The local `terraform.tfstate` file is intentionally excluded from source control.

## Provider

The project uses the AzureRM Terraform provider.

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
```

## GitHub Actions CI/CD

GitHub Actions is used to automate Terraform validation and deployment.

The workflow performs operations such as:

```text
Terraform Format
       |
       v
Terraform Init
       |
       v
Terraform Validate
       |
       v
Terraform Plan
       |
       v
Terraform Apply
```

## Azure Authentication with OIDC

GitHub Actions authenticates to Azure using **OpenID Connect (OIDC)** instead of a long-lived client secret.

```text
GitHub Actions
      |
      | OIDC Token
      v
Microsoft Entra ID
      |
      | Federated Credential
      v
Azure App Registration
      |
      v
Azure Resources
```

A federated credential is configured on the Azure App Registration to establish trust between GitHub Actions and Azure.

This provides passwordless authentication and avoids storing an Azure client secret in GitHub repository secrets.

## Terraform Commands

Run Terraform from the Dev environment:

```bash
cd environments/dev
```

### Initialize

```bash
terraform init
```

If the backend configuration has changed:

```bash
terraform init -reconfigure
```

### Format

```bash
terraform fmt -recursive
```

### Validate

```bash
terraform validate
```

### Plan

```bash
terraform plan
```

### Apply

```bash
terraform apply
```

### Destroy

Use carefully:

```bash
terraform destroy
```

Terraform destroys only resources managed by the Terraform configuration. The existing Resource Group is not created or destroyed by this project.

## Deployment Workflow

```text
1. Modify Terraform code
        |
2. Run terraform fmt
        |
3. Run terraform validate
        |
4. Run terraform plan
        |
5. Review infrastructure changes
        |
6. Apply changes
        |
7. Push changes to GitHub
        |
8. GitHub Actions validates and deploys
```

## Security Practices

The project follows these practices:

* Terraform state is stored remotely.
* Terraform state is not committed to Git.
* Azure authentication uses OIDC.
* No Azure client secret is stored in the repository.
* Infrastructure is organized using reusable modules.
* The existing Resource Group is referenced rather than managed by Terraform.
* `.gitignore` prevents sensitive Terraform files from being committed.

## What I Practiced

Through this project I worked with:

* Azure Infrastructure
* Terraform
* Terraform modules
* AzureRM provider
* Existing Azure Resource Groups
* Remote Terraform backend
* Azure Storage Account
* Azure Virtual Network
* Subnets
* Network Security Groups
* Azure Virtual Machines
* Terraform variables and outputs
* Terraform state management
* Git and GitHub
* GitHub Actions
* Microsoft Entra ID
* GitHub Actions OIDC authentication
* Infrastructure CI/CD

## Future Improvements

Planned improvements include:

* Add Terraform plan approval before deployment
* Add additional Azure resources
* Improve network security rules
* Add automated infrastructure testing
* Add Terraform linting and security scanning
* Extend the infrastructure with additional Azure services
* Introduce additional environments when required

## Disclaimer

This is a hands-on learning project created to demonstrate practical experience with Azure infrastructure automation, Terraform, CI/CD, and cloud authentication.

The architecture can be extended and adapted for real-world enterprise environments.
