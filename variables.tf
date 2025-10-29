# ============================================
# SUBSCRIPTION & RESOURCE GROUP VARIABLES
# ============================================

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true
}

variable "existing_resource_group_name" {
  description = "Name of the existing resource group where all resources will be deployed"
  type        = string
}

variable "existing_vnet_name" {
  description = "Name of the existing VNet containing the subnets"
  type        = string
}

# ============================================
# EXISTING NETWORK RESOURCES
# ============================================

variable "external_subnet_name" {
  description = "Name of the external subnet (facing Internet/upstream)"
  type        = string
}

variable "internal_subnet_name" {
  description = "Name of the internal subnet (facing backend resources)"
  type        = string
}

# ============================================
# PROJECT & ENVIRONMENT VARIABLES
# ============================================

variable "project_name" {
  description = "Project name for resource naming convention"
  type        = string
  default     = "tse-automation"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "owner_tag" {
  description = "Owner tag for resources"
  type        = string
  default     = "Infrastructure Team"
}

# ============================================
# KEY VAULT VARIABLES (FOR SECRETS)
# ============================================

variable "key_vault_resource_group_name" {
  description = "Resource group name where existing Key Vault is located"
  type        = string
}

variable "key_vault_name" {
  description = "Name of existing Key Vault containing SSH public key secret"
  type        = string
}

variable "ssh_public_key_secret_name" {
  description = "Name of the Key Vault secret containing SSH public key"
  type        = string
}

# ============================================
# TERRAFORM STATE BACKEND VARIABLES
# ============================================

variable "state_storage_account_name" {
  description = "Name of the storage account for Terraform state"
  type        = string
}

variable "state_storage_resource_group_name" {
  description = "Resource group name where state storage account is located"
  type        = string
}

variable "state_container_name" {
  description = "Name of the blob container for storing Terraform state"
  type        = string
  default     = "tfstate"
}

variable "state_key" {
  description = "Name of the state file blob (e.g., tse-automation/dev.tfstate)"
  type        = string
}

# ============================================
# CISCO FTDv VMSS VARIABLES
# ============================================

variable "ftdv_instance_count" {
  description = "Number of Cisco FTDv instances in VMSS"
  type        = number
  default     = 2

  validation {
    condition     = var.ftdv_instance_count >= 1 && var.ftdv_instance_count <= 10
    error_message = "FTDv instance count must be between 1 and 10."
  }
}

variable "ftdv_vmss_sku" {
  description = "VM size for FTDv VMSS instances"
  type        = string
  default     = "Standard_D2s_v3"
}

# ============================================
# CISCO FTDv MARKETPLACE IMAGE VARIABLES
# ============================================

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
  description = "Cisco FTDv image SKU (e.g., ftdv-intro-6.10.1, ftdv-standard-6.10.1, ftdv-advanced-6.10.1)"
  type        = string
  default     = "ftdv-intro-6.10.1"

  validation {
    condition = contains([
      "ftdv-intro-6.10.1",
      "ftdv-standard-6.10.1",
      "ftdv-advanced-6.10.1",
      "ftdv-intro-6.11.0",
      "ftdv-standard-6.11.0",
      "ftdv-advanced-6.11.0",
      "ftdv-intro-7.0.0",
      "ftdv-standard-7.0.0",
      "ftdv-advanced-7.0.0",
    ], var.ftdv_image_sku)
    error_message = "FTDv image SKU must be a valid Cisco FTDv offering from Azure Marketplace."
  }
}

variable "ftdv_image_version" {
  description = "Cisco FTDv image version (use 'latest' for most recent)"
  type        = string
  default     = "latest"
}

# ============================================
# VIRTUAL MACHINE STORAGE VARIABLES
# ============================================

variable "os_disk_type" {
  description = "Managed disk type for OS disk"
  type        = string
  default     = "Premium_LRS"

  validation {
    condition     = contains(["Premium_LRS", "Standard_LRS", "StandardSSD_LRS"], var.os_disk_type)
    error_message = "OS disk type must be Premium_LRS, Standard_LRS, or StandardSSD_LRS."
  }
}

# ============================================
# SSH & ADMIN ACCESS VARIABLES
# ============================================

variable "admin_username" {
  description = "Admin username for VMSS instances"
  type        = string
  default     = "azureuser"
}

# ============================================
# NETWORK SECURITY VARIABLES
# ============================================

variable "management_source_ip" {
  description = "CIDR block or IP for management access (SSH). Use '*' to allow all"
  type        = string
  default     = "*"
}

variable "allowed_internal_cidrs" {
  description = "List of CIDR blocks allowed for internal traffic"
  type        = list(string)
}

# ============================================
# EXTERNAL LOAD BALANCER VARIABLES (OPTIONAL)
# ============================================

variable "enable_external_lb" {
  description = "Whether to deploy an external load balancer for FTDv"
  type        = bool
  default     = false
}

variable "external_health_probe_protocol" {
  description = "Health probe protocol for external LB (Http, Https, Tcp)"
  type        = string
  default     = "Http"

  validation {
    condition     = contains(["Http", "Https", "Tcp"], var.external_health_probe_protocol)
    error_message = "Health probe protocol must be Http, Https, or Tcp."
  }
}

variable "external_health_probe_port" {
  description = "Health probe port for external LB"
  type        = number
  default     = 80

  validation {
    condition     = var.external_health_probe_port >= 1 && var.external_health_probe_port <= 65535
    error_message = "Health probe port must be between 1 and 65535."
  }
}

variable "external_health_probe_path" {
  description = "Health probe path for external LB (for Http/Https protocols)"
  type        = string
  default     = "/"
}

variable "external_lb_idle_timeout" {
  description = "Idle timeout for external LB connections in minutes"
  type        = number
  default     = 4

  validation {
    condition     = var.external_lb_idle_timeout >= 4 && var.external_lb_idle_timeout <= 30
    error_message = "Idle timeout must be between 4 and 30 minutes."
  }
}

variable "external_lb_rules" {
  description = "Load balancing rules for external LB with variable backend ports"
  type = map(object({
    protocol       = string
    frontend_port  = number
    backend_port   = number
  }))
  default = {
    http = {
      protocol       = "Tcp"
      frontend_port  = 80
      backend_port   = 80
    }
    https = {
      protocol       = "Tcp"
      frontend_port  = 443
      backend_port   = 443
    }
  }

  validation {
    condition = alltrue([
      for rule in values(var.external_lb_rules) :
      contains(["Tcp", "Udp"], rule.protocol)
    ])
    error_message = "LB rule protocol must be Tcp or Udp."
  }
}

# ============================================
# INTERNAL LOAD BALANCER VARIABLES
# ============================================

variable "ilb_static_ip" {
  description = "Static private IP for ILB frontend (use empty string for dynamic)"
  type        = string
  default     = ""
}

variable "health_probe_protocol" {
  description = "Health probe protocol for ILB (Http, Https, Tcp)"
  type        = string
  default     = "Http"

  validation {
    condition     = contains(["Http", "Https", "Tcp"], var.health_probe_protocol)
    error_message = "Health probe protocol must be Http, Https, or Tcp."
  }
}

variable "health_probe_port" {
  description = "Health probe port for ILB"
  type        = number
  default     = 80

  validation {
    condition     = var.health_probe_port >= 1 && var.health_probe_port <= 65535
    error_message = "Health probe port must be between 1 and 65535."
  }
}

variable "health_probe_path" {
  description = "Health probe path for ILB (for Http/Https protocols)"
  type        = string
  default     = "/"
}

variable "health_probe_interval" {
  description = "Health probe interval in seconds"
  type        = number
  default     = 15

  validation {
    condition     = var.health_probe_interval >= 5 && var.health_probe_interval <= 300
    error_message = "Health probe interval must be between 5 and 300 seconds."
  }
}

variable "health_probe_unhealthy_threshold" {
  description = "Number of failed probes before marking unhealthy"
  type        = number
  default     = 3

  validation {
    condition     = var.health_probe_unhealthy_threshold >= 2 && var.health_probe_unhealthy_threshold <= 10
    error_message = "Unhealthy threshold must be between 2 and 10."
  }
}

variable "ilb_idle_timeout" {
  description = "Idle timeout for ILB connections in minutes"
  type        = number
  default     = 4

  validation {
    condition     = var.ilb_idle_timeout >= 4 && var.ilb_idle_timeout <= 30
    error_message = "Idle timeout must be between 4 and 30 minutes."
  }
}

variable "ilb_rules" {
  description = "Load balancing rules for ILB with variable backend ports"
  type = map(object({
    protocol           = string
    frontend_port      = number
    backend_port       = number
    enable_floating_ip = bool
  }))
  default = {
    http = {
      protocol           = "Tcp"
      frontend_port      = 80
      backend_port       = 80
      enable_floating_ip = false
    }
    https = {
      protocol           = "Tcp"
      frontend_port      = 443
      backend_port       = 443
      enable_floating_ip = false
    }
  }

  validation {
    condition = alltrue([
      for rule in values(var.ilb_rules) :
      contains(["Tcp", "Udp"], rule.protocol)
    ])
    error_message = "LB rule protocol must be Tcp or Udp."
  }
}

# ============================================
# UDR (USER-DEFINED ROUTES) VARIABLES
# ============================================

variable "enable_external_default_route" {
  description = "Whether to configure a default route (0.0.0.0/0) for external subnet"
  type        = bool
  default     = false
}

variable "external_default_route_next_hop_type" {
  description = "Next hop type for default route in external subnet (Internet, VirtualAppliance, None, VirtualNetworkGateway)"
  type        = string
  default     = "Internet"

  validation {
    condition     = contains(["Internet", "VirtualAppliance", "None", "VirtualNetworkGateway"], var.external_default_route_next_hop_type)
    error_message = "Next hop type must be Internet, VirtualAppliance, None, or VirtualNetworkGateway."
  }
}

variable "external_default_route_next_hop_ip" {
  description = "Next hop IP address for external subnet default route (required if next_hop_type is VirtualAppliance)"
  type        = string
  default     = ""
}

variable "external_custom_routes" {
  description = "Custom routes for external subnet"
  type = map(object({
    name           = string
    address_prefix = string
    next_hop_type  = string
    next_hop_ip    = optional(string, "")
  }))
  default = {}

  validation {
    condition = alltrue([
      for route in values(var.external_custom_routes) :
      contains(["Internet", "VirtualAppliance", "None", "VirtualNetworkGateway"], route.next_hop_type)
    ])
    error_message = "Next hop type must be Internet, VirtualAppliance, None, or VirtualNetworkGateway."
  }
}

variable "enable_internal_default_route" {
  description = "Whether to configure a default route (0.0.0.0/0) for internal subnet"
  type        = bool
  default     = false
}

variable "internal_default_route_next_hop_type" {
  description = "Next hop type for default route in internal subnet (Internet, VirtualAppliance, None, VirtualNetworkGateway)"
  type        = string
  default     = "VirtualAppliance"

  validation {
    condition     = contains(["Internet", "VirtualAppliance", "None", "VirtualNetworkGateway"], var.internal_default_route_next_hop_type)
    error_message = "Next hop type must be Internet, VirtualAppliance, None, or VirtualNetworkGateway."
  }
}

variable "internal_default_route_next_hop_ip" {
  description = "Next hop IP address for internal subnet default route (required if next_hop_type is VirtualAppliance)"
  type        = string
  default     = ""
}

variable "internal_custom_routes" {
  description = "Custom routes for internal subnet (e.g., route backend traffic through FTDv)"
  type = map(object({
    name           = string
    address_prefix = string
    next_hop_type  = string
    next_hop_ip    = optional(string, "")
  }))
  default = {}

  validation {
    condition = alltrue([
      for route in values(var.internal_custom_routes) :
      contains(["Internet", "VirtualAppliance", "None", "VirtualNetworkGateway"], route.next_hop_type)
    ])
    error_message = "Next hop type must be Internet, VirtualAppliance, None, or VirtualNetworkGateway."
  }
}
