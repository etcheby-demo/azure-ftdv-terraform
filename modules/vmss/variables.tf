variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "external_subnet_id" {
  description = "ID of the external subnet"
  type        = string
}

variable "internal_subnet_id" {
  description = "ID of the internal subnet"
  type        = string
}

variable "external_nsg_id" {
  description = "ID of the external NSG"
  type        = string
}

variable "internal_nsg_id" {
  description = "ID of the internal NSG"
  type        = string
}

variable "admin_username" {
  description = "Admin username for VMSS instances"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH public key content"
  type        = string
  sensitive   = true
}

variable "ftdv_instance_count" {
  description = "Number of Cisco FTDv instances in VMSS"
  type        = number

  validation {
    condition     = var.ftdv_instance_count >= 1 && var.ftdv_instance_count <= 10
    error_message = "FTDv instance count must be between 1 and 10."
  }
}

variable "ftdv_vmss_sku" {
  description = "VM size for FTDv VMSS instances"
  type        = string
}

variable "ftdv_image_publisher" {
  description = "Cisco FTDv image publisher"
  type        = string
  default     = "cisco"
}

variable "ftdv_image_offer" {
  description = "Cisco FTDv image offer"
  type        = string
  default     = "cisco-ftdv"
}

variable "ftdv_image_sku" {
  description = "Cisco FTDv image SKU"
  type        = string
}

variable "ftdv_image_version" {
  description = "Cisco FTDv image version"
  type        = string
  default     = "latest"
}

variable "os_disk_type" {
  description = "Managed disk type for OS disk"
  type        = string
  default     = "Premium_LRS"

  validation {
    condition     = contains(["Premium_LRS", "Standard_LRS", "StandardSSD_LRS"], var.os_disk_type)
    error_message = "OS disk type must be Premium_LRS, Standard_LRS, or StandardSSD_LRS."
  }
}

variable "external_lb_backend_pool_ids" {
  description = "IDs of external load balancer backend pools"
  type        = list(string)
  default     = []
}

variable "internal_lb_backend_pool_ids" {
  description = "IDs of internal load balancer backend pools"
  type        = list(string)
  default     = []
}
