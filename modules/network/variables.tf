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

variable "management_source_ip" {
  description = "CIDR block or IP for management access (SSH)"
  type        = string
}

variable "allowed_internal_cidrs" {
  description = "List of CIDR blocks allowed for internal traffic"
  type        = list(string)
}

variable "enable_external_default_route" {
  description = "Whether to configure a default route (0.0.0.0/0) for external subnet"
  type        = bool
  default     = false
}

variable "external_default_route_next_hop_type" {
  description = "Next hop type for default route in external subnet"
  type        = string
  default     = "Internet"

  validation {
    condition     = contains(["Internet", "VirtualAppliance", "None", "VirtualNetworkGateway"], var.external_default_route_next_hop_type)
    error_message = "Next hop type must be Internet, VirtualAppliance, None, or VirtualNetworkGateway."
  }
}

variable "external_default_route_next_hop_ip" {
  description = "Next hop IP address for external subnet default route"
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
  description = "Next hop type for default route in internal subnet"
  type        = string
  default     = "VirtualAppliance"

  validation {
    condition     = contains(["Internet", "VirtualAppliance", "None", "VirtualNetworkGateway"], var.internal_default_route_next_hop_type)
    error_message = "Next hop type must be Internet, VirtualAppliance, None, or VirtualNetworkGateway."
  }
}

variable "internal_default_route_next_hop_ip" {
  description = "Next hop IP address for internal subnet default route"
  type        = string
  default     = ""
}

variable "internal_custom_routes" {
  description = "Custom routes for internal subnet"
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
