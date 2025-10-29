# ============================================
# DATA SOURCES - EXISTING RESOURCES
# ============================================

data "azurerm_resource_group" "existing" {
  name = var.existing_resource_group_name
}

data "azurerm_virtual_network" "existing" {
  name                = var.existing_vnet_name
  resource_group_name = data.azurerm_resource_group.existing.name
}

data "azurerm_subnet" "external" {
  name                 = var.external_subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  resource_group_name  = data.azurerm_resource_group.existing.name
}

data "azurerm_subnet" "internal" {
  name                 = var.internal_subnet_name
  virtual_network_name = data.azurerm_virtual_network.existing.name
  resource_group_name  = data.azurerm_resource_group.existing.name
}

# ============================================
# KEY VAULT DATA SOURCE - SSH PUBLIC KEY
# ============================================

data "azurerm_key_vault" "existing" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = var.ssh_public_key_secret_name
  key_vault_id = data.azurerm_key_vault.existing.id
}

# ============================================
# LOCAL VARIABLES - COMMON TAGS
# ============================================

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Owner       = var.owner_tag
    CreatedDate = formatdate("YYYY-MM-DD", timestamp())
  }
}
