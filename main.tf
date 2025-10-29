# ============================================
# NETWORK MODULE - NSGs, ROUTE TABLES, UDRs
# ============================================

module "network" {
  source = "./modules/network"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  external_subnet_id = data.azurerm_subnet.external.id
  internal_subnet_id = data.azurerm_subnet.internal.id

  project_name            = var.project_name
  environment             = var.environment
  common_tags             = local.common_tags
  management_source_ip    = var.management_source_ip
  allowed_internal_cidrs  = var.allowed_internal_cidrs

  # External Subnet UDR Configuration
  enable_external_default_route     = var.enable_external_default_route
  external_default_route_next_hop_type = var.external_default_route_next_hop_type
  external_default_route_next_hop_ip   = var.external_default_route_next_hop_ip
  external_custom_routes            = var.external_custom_routes

  # Internal Subnet UDR Configuration
  enable_internal_default_route     = var.enable_internal_default_route
  internal_default_route_next_hop_type = var.internal_default_route_next_hop_type
  internal_default_route_next_hop_ip   = var.internal_default_route_next_hop_ip
  internal_custom_routes            = var.internal_custom_routes
}

# ============================================
# VMSS MODULE - CISCO FTDv DEPLOYMENT
# ============================================

module "vmss" {
  source = "./modules/vmss"

  resource_group_name = data.azurerm_resource_group.existing.name
  location            = data.azurerm_resource_group.existing.location

  project_name       = var.project_name
  environment        = var.environment
  common_tags        = local.common_tags
  admin_username     = var.admin_username
  ssh_public_key     = data.azurerm_key_vault_secret.ssh_public_key.value

  external_subnet_id = data.azurerm_subnet.external.id
  internal_subnet_id = data.azurerm_subnet.internal.id

  ftdv_instance_count    = var.ftdv_instance_count
  ftdv_vmss_sku          = var.ftdv_vmss_sku
  ftdv_image_publisher   = var.ftdv_image_publisher
  ftdv_image_offer       = var.ftdv_image_offer
  ftdv_image_sku         = var.ftdv_image_sku
