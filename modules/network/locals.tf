locals {
  nsg_external_name = "${var.project_name}-ftdv-ext-nsg"
  nsg_internal_name = "${var.project_name}-ftdv-int-nsg"
  rt_external_name  = "${var.project_name}-external-rt"
  rt_internal_name  = "${var.project_name}-internal-rt"
}
