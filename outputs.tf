# ============================================
# NETWORK MODULE OUTPUTS
# ============================================

output "external_nsg_id" {
  value       = module.network.external_nsg_id
  description = "External Subnet Network Security Group ID"
}

output "internal_nsg_id" {
  value       = module.network.internal_nsg_id
  description = "Internal Subnet Network Security Group ID"
}

output "external_route_table_id" {
  value       = module.network.external_route_table_id
  description = "External Subnet Route Table ID"
}

output "internal_route_table_id" {
  value       = module.network.internal_route_table_id
  description = "Internal Subnet Route Table ID"
}

output "external_routes" {
  value       = module.network.external_routes
  description = "External Subnet Routes Configuration"
}

output "internal_routes" {
  value       = module.network.internal_routes
  description = "Internal Subnet Routes Configuration"
}

# ============================================
# VMSS MODULE OUTPUTS
# ============================================

output "ftdv_vmss_id" {
  value       = module.vmss.ftdv_vmss_id
  description = "Cisco FTDv VMSS ID"
}

output "ftdv_vmss_name" {
  value       = module.vmss.ftdv_vmss_name
  description = "Cisco FTDv VMSS Name"
}

output "ftdv_vmss_instance_count" {
  value       = module.vmss.ftdv_vmss_instance_count
  description = "Number of FTDv instances in VMSS"
}

output "vmss_external_nic_ids" {
  value       = module.vmss.vmss_external_nic_ids
  description = "FTDv VMSS External Network Interface IDs"
  sensitive   = true
}

output "vmss_internal_nic_ids" {
  value       = module.vmss.vmss_internal_nic_ids
  description = "FTDv VMSS Internal Network Interface IDs"
  sensitive   = true
}

output "vmss_external_private_ips" {
  value       = module.vmss.vmss_external_private_ips
  description = "FTDv VMSS External Private IPs"
}

output "vmss_internal_private_ips" {
  value       = module.vmss.vmss_internal_private_ips
  description = "FTDv VMSS Internal Private IPs"
}

output "vmss_public_ips" {
  value       = module.vmss.vmss_public_ips
  description = "FTDv VMSS Public IPs (if enabled)"
}

# ============================================
# LOAD BALANCER MODULE OUTPUTS
# ============================================

output "ilb_id" {
  value       = module.load_balancer.ilb_id
  description = "Internal Load Balancer ID"
}

output "ilb_private_ip" {
  value       = module.load_balancer.ilb_private_ip
  description = "Internal Load Balancer Private IP Address"
}

output "ilb_backend_pool_id" {
  value       = module.load_balancer.ilb_backend_pool_id
  description = "Internal Load Balancer Backend Pool ID"
}

output "ilb_rules" {
  value       = module.load_balancer.ilb_rules
  description = "Internal Load Balancer Rules Configuration"
}

output "external_lb_id" {
  value       = module.load_balancer.external_lb_id
  description = "External Load Balancer ID (if enabled)"
}

output "external_lb_public_ip" {
  value       = module.load_balancer.external_lb_public_ip
  description = "External Load Balancer Public IP (if enabled)"
}

output "external_lb_backend_pool_id" {
  value       = module.load_balancer.external_lb_backend_pool_id
  description = "External Load Balancer Backend Pool ID (if enabled)"
}

output "external_lb_rules" {
  value       = module.load_balancer.external_lb_rules
  description = "External Load Balancer Rules Configuration"
}

# ============================================
# ENVIRONMENT & RESOURCE GROUP INFO
# ============================================

output "deployment_environment" {
  value       = var.environment
  description = "Deployment environment (dev/staging/prod)"
}

output "resource_group_name" {
  value       = data.azurerm_resource_group.existing.name
  description = "Resource group name where resources are deployed"
}

output "vnet_name" {
  value       = data.azurerm_virtual_network.existing.name
  description = "Virtual Network name"
}

output "external_subnet_name" {
  value       = data.azurerm_subnet.external.name
  description = "External Subnet name"
}

output "external_subnet_cidr" {
  value       = data.azurerm_subnet.external.address_prefixes
  description = "External Subnet CIDR block(s)"
}

output "internal_subnet_name" {
  value       = data.azurerm_subnet.internal.name
  description = "Internal Subnet name"
}

output "internal_subnet_cidr" {
  value       = data.azurerm_subnet.internal.address_prefixes
  description = "Internal Subnet CIDR block(s)"
}
