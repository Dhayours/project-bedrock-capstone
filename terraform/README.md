# Terraform (Bedrock)

This folder contains Terraform configuration for the Bedrock capstone.

Key files:
- main.tf: core infrastructure (EKS + supporting AWS resources)
- versions.tf / providers.tf: provider configuration
- variables.tf: input variables used by the configuration
- eks-admin-access.tf: EKS access configuration (if used)

Notes:
- Do not commit `.terraform/`, `*.tfstate*`, or build artifacts like `*.zip`.

Testing CI/CD pipeline
