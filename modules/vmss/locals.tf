locals {
  vmss_name                  = "${var.project_name}-ftdv-vmss"
  vmss_external_nic_name     = "${var.project_name}-ftdv-ext-nic"
  vmss_internal_nic_name     = "${var.project_name}-ftdv-int-nic"
  vmss_public_ip_name        = "${var.project_name}-ftdv-pip"
  external_ipconfig_name     = "external-ipconfig"
  internal_ipconfig_name     = "internal-ipconfig"
}
