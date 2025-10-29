output "ftdv_vmss_id" {
  value       = azurerm_linux_virtual_machine_scale_set.ftdv.id
  description = "Cisco FTDv VMSS ID"
}

output "ftdv_vmss_name" {
  value       = azurerm_linux_virtual_machine_scale_set.ftdv.name
  description = "Cisco FTDv VMSS Name"
}

output "ftdv_vmss_instance_count" {
  value       = azurerm_linux_virtual_machine_scale_set.ftdv.instances
  description = "Number of FTDv instances in VMSS"
}

output "vmss_external_nic_ids" {
  value       = [azurerm_linux_virtual_machine_scale_set.ftdv.network_interface[0].id]
  description = "External Network Interface IDs"
  sensitive   = true
}

output "vmss_internal_nic_ids" {
  value       = [azurerm_linux_virtual_machine_scale_set.ftdv.network_interface[1].id]
  description = "Internal Network Interface IDs"
  sensitive   = true
}

output "vmss_external_private_ips" {
  value       = [for ni in azurerm_linux_virtual_machine_scale_set.ftdv.network_interface[0].ip_configuration : ni.private_ip_address]
  description = "FTDv VMSS External Private IPs"
}

output "vmss_internal_private_ips" {
  value       = [for ni in azurerm_linux_virtual_machine_scale_set.ftdv.network_interface[1].ip_configuration : ni.private_ip_address]
  description = "FTDv VMSS Internal Private IPs"
}

output "vmss_public_ips" {
  value       = [for nic in azurerm_linux_virtual_machine_scale_set.ftdv.network_interface : [for ipc in nic.ip_configuration : ipc.public_ip_address]]
  description = "FTDv VMSS Public IPs"
}
