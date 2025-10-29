# Azure FTDv Terraform

Modular Terraform configuration for deploying Cisco FTDv as a Virtual Machine Scale Set (VMSS) with Internal and External Load Balancers on Azure.

## Features

- **Modular Architecture**: Separate modules for networking, VMSS, and load balancers
- **Cisco FTDv VMSS**: Marketplace image deployment with dual network interfaces
- **Internal Load Balancer (ILB)**: For backend pool traffic with variable port mapping
- **External Load Balancer**: Optional internet-facing load balancer
- **Network Security**: NSGs with HTTP/HTTPS and SSH rules (no RDP)
- **User-Defined Routes**: Full UDR support for custom routing policies
- **Key Vault Integration**: SSH public keys retrieved from Azure Key Vault
- **Entra ID Authentication**: Remote state using Azure Storage with Entra ID (no keys in code)
- **Variable Backend Ports**: Frontend ports can map to different backend ports

## Project Structure

```
azure-ftdv-terraform/
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── locals.tf
├── terraform.tfvars.dev
├── backend-config.hcl.example
├── .gitignore
└── modules/
    ├── network/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── locals.tf
    ├── vmss/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── locals.tf
    └── load_balancer/
        ├── main.tf
        ├── variables.tf
        ├── outputs.tf
        └── locals.tf
```

## Prerequisites

### Azure Resources (Must Exist)
- Resource Group
- Virtual Network with external and internal subnets
- Key Vault containing SSH public key secret
- Storage Account for Terraform state

### Local Requirements
- Terraform >= 1.0
- Azure CLI authenticated: `az login`
- SSH public key stored in Key Vault

### Marketplace Agreement
```bash
az vm image terms accept \
  --publisher cisco \
  --offer cisco-ftdv \
  --plan ftdv-intro-6.10.1
```

## Quick Start

### 1. Initialize Backend
```bash
terraform init -backend-config=backend-config.hcl
```

### 2. Configure Variables
```bash
cp terraform.tfvars.dev terraform.tfvars
nano terraform.tfvars
```

Update critical values:
- subscription_id
- existing_resource_group_name
- existing_vnet_name
- external_subnet_name
- internal_subnet_name
- key_vault_name
- ssh_public_key_secret_name
- state_storage_account_name

### 3. Validate & Plan
```bash
terraform validate
terraform plan -var-file=terraform.tfvars
```

### 4. Deploy
```bash
terraform apply -var-file=terraform.tfvars
```

## Configuration Examples

### Variable Backend Ports
```hcl
ilb_rules = {
  http = {
    protocol           = "Tcp"
    frontend_port      = 80
    backend_port       = 8080
    enable_floating_ip = false
  }
}
```

### User-Defined Routes
```hcl
internal_custom_routes = {
  "route-to-app-vnet" = {
    name           = "route-to-app-vnet"
    address_prefix = "10.1.0.0/16"
    next_hop_type  = "VirtualAppliance"
    next_hop_ip    = "10.0.3.10"
  }
}
```

### Enable External Load Balancer
```hcl
enable_external_lb = true
```

## Scaling
```bash
terraform apply -var="ftdv_instance_count=4"
```

## Destroy
```bash
terraform destroy -var-file=terraform.tfvars
```

## Security Notes

- HTTP/HTTPS (80/443): Allowed inbound from any source
- SSH (22): Allowed from management_source_ip (configurable)
- All other inbound: Denied by default
- All outbound: Allowed by default

Restrict management access:
```hcl
management_source_ip = "203.0.113.0/24"
```

## References

- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices.html)
- [Cisco FTDv on Azure](https://www.cisco.com/c/en/us/products/security/firepower-threat-defense/)
