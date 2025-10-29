output "external_nsg_id" {
  value       = azurerm_network_security_group.external.id
  description = "External NSG ID"
}

output "internal_nsg_id" {
  value       = azurerm_network_security_group.internal.id
  description = "Internal NSG ID"
}

output "external_route_table_id" {
  value       = azurerm_route_table.external.id
  description = "External Route Table ID"
}

output "internal_route_table_id" {
  value       = azurerm_route_table.internal.id
  description = "Internal Route Table ID"
}

output "external_routes" {
  value = {
    for route in concat(
      azurerm_route.external_default[*],
      [for r in azurerm_route.external_custom : r]
    ) : route.name => {
      address_prefix         = route.address_prefix
      next_hop_type          = route.next_hop_type
      next_hop_in_ip_address = route.next_hop_in_ip_address
    }
  }
  description = "External Subnet Routes Configuration"
}

output "internal_routes" {
  value = {
    for route in concat(
      azurerm_route.internal_default[*],
      [for r in azurerm_route.internal_custom : r]
    ) : route.name => {
      address_prefix         = route.address_prefix
      next_hop_type          = route.next_hop_type
      next_hop_in_ip_address = route.next_hop_in_ip_address
    }
  }
  description = "Internal Subnet Routes Configuration"
}
