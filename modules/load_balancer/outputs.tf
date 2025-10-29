output "ilb_id" {
  value       = azurerm_lb.internal.id
  description = "Internal Load Balancer ID"
}

output "ilb_private_ip" {
  value       = azurerm_lb.internal.private_ip_addresses[0]
  description = "Internal Load Balancer Private IP"
}

output "ilb_backend_pool_id" {
  value       = azurerm_lb_backend_address_pool.ilb.id
  description = "ILB Backend Pool ID"
}

output "ilb_rules" {
  value = {
    for rule_key, rule in azurerm_lb_rule.ilb : rule_key => {
      protocol           = rule.protocol
      frontend_port      = rule.frontend_port
      backend_port       = rule.backend_port
      enable_floating_ip = rule.enable_floating_ip
    }
  }
  description = "Internal Load Balancer Rules Configuration"
}

output "external_lb_id" {
  value       = var.enable_external_lb ? azurerm_lb.external[0].id : null
  description = "External Load Balancer ID"
}

output "external_lb_public_ip" {
  value       = var.enable_external_lb ? azurerm_public_ip.external_lb[0].ip_address : null
  description = "External Load Balancer Public IP"
}

output "external_lb_backend_pool_id" {
  value       = var.enable_external_lb ? azurerm_lb_backend_address_pool.external[0].id : null
  description = "External LB Backend Pool ID"
}

output "external_lb_rules" {
  value = var.enable_external_lb ? {
    for rule_key, rule in azurerm_lb_rule.external : rule_key => {
      protocol      = rule.protocol
      frontend_port = rule.frontend_port
      backend_port  = rule.backend_port
    }
  } : {}
  description = "External Load Balancer Rules Configuration"
}
