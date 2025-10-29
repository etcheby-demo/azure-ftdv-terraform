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

variable "internal_subnet_id" {
  description = "ID of the internal subnet for ILB"
  type        = string
}

variable "ilb_static_ip" {
  description = "Static private IP for ILB frontend"
  type        = string
  default     = ""
}

variable "health_probe_protocol" {
  description = "Health probe protocol for ILB"
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
  description = "Health probe path for ILB"
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
  description = "Load balancing rules for ILB"
  type = map(object({
    protocol           = string
    frontend_port      = number
    backend_port       = number
    enable_floating_ip = bool
  }))

  validation {
    condition = alltrue([
      for rule in values(var.ilb_rules) :
      contains(["Tcp", "Udp"], rule.protocol)
    ])
    error_message = "LB rule protocol must be Tcp or Udp."
  }
}

variable "vmss_internal_nic_ids" {
  description = "List of VMSS internal NIC IDs"
  type        = list(string)
  default     = []
}

variable "enable_external_lb" {
  description = "Whether to deploy an external load balancer"
  type        = bool
  default     = false
}

variable "external_health_probe_protocol" {
  description = "Health probe protocol for external LB"
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
  description = "Health probe path for external LB"
  type        = string
  default     = "/"
}

variable "external_health_probe_interval" {
  description = "Health probe interval for external LB"
  type        = number
  default     = 15

  validation {
    condition     = var.external_health_probe_interval >= 5 && var.external_health_probe_interval <= 300
    error_message = "Health probe interval must be between 5 and 300 seconds."
  }
}

variable "external_health_probe_unhealthy_threshold" {
  description = "Unhealthy threshold for external LB"
  type        = number
  default     = 3

  validation {
    condition     = var.external_health_probe_unhealthy_threshold >= 2 && var.external_health_probe_unhealthy_threshold <= 10
    error_message = "Unhealthy threshold must be between 2 and 10."
  }
}

variable "external_lb_idle_timeout" {
  description = "Idle timeout for external LB"
  type        = number
  default     = 4

  validation {
    condition     = var.external_lb_idle_timeout >= 4 && var.external_lb_idle_timeout <= 30
    error_message = "Idle timeout must be between 4 and 30 minutes."
  }
}

variable "external_lb_rules" {
  description = "Load balancing rules for external LB"
  type = map(object({
    protocol      = string
    frontend_port = number
    backend_port  = number
  }))
  default = {}

  validation {
    condition = alltrue([
      for rule in values(var.external_lb_rules) :
      contains(["Tcp", "Udp"], rule.protocol)
    ])
    error_message = "LB rule protocol must be Tcp or Udp."
  }
}

variable "vmss_external_nic_ids" {
  description = "List of VMSS external NIC IDs"
  type        = list(string)
  default     = []
}
