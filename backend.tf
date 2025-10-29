# ============================================
# TERRAFORM BACKEND CONFIGURATION
# ============================================
# Uses Azure Storage Account with Entra ID authentication

terraform {
  backend "azurerm" {
    # These values will be provided via backend config file or CLI
    # Example usage:
    # terraform init -backend-config="backend-config.hcl"
    # Or via environment variables:
    # ARM_ACCESS_KEY, ARM_STORAGE_ACCOUNT_NAME, ARM_CONTAINER_NAME
  }
}

# ============================================
# REQUIRED PROVIDERS
# ============================================

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# ============================================
# PROVIDER CONFIGURATION
# ============================================

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = false
      recover_soft_deleted_key_vaults = true
    }
  }

  subscription_id = var.subscription_id
}
