resource "azurerm_lb" "internal" {
  name                = "${var.project_name}-ilb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.common_tags

  frontend_ip_configuration {
    name                          = "internal-frontend"
    subnet_id                     = var.internal_subnet_id
    private_ip_address_allocation = var.ilb_static_ip != "" ? "Static" : "Dynamic"
    private_ip_address            = var.ilb_static_ip != "" ? var.ilb_static_ip : null
  }
}

resource "azurerm_lb_backend_address_pool" "ilb" {
  loadbalancer_id = azurerm_lb.internal.id
  name            = "${var.project_name}-ilb-backend-pool"
}

resource "azurerm_lb_probe" "ilb" {
  loadbalancer_id = azurerm_lb.internal.id
  name            = "${var.project_name}-ilb-health-probe"
  protocol        = var.health_probe_protocol
  port            = var.health_probe_port
  request_path    = var.health_probe_path
  interval_in_seconds = var.health_probe_interval
  number_of_probes = var.health_probe_unhealthy_threshold
}

resource "azurerm_lb_rule" "ilb" {
  for_each = var.ilb_rules

  loadbalancer_id                = azurerm_lb.internal.id
  name                           = "${var.project_name}-ilb-rule-${each.key}"
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = "internal-frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.ilb.id]
  probe_id                       = azurerm_lb_probe.ilb.id
  enable_floating_ip             = each.value.enable_floating_ip
  idle_timeout_in_minutes        = var.ilb_idle_timeout
}

resource "azurerm_network_interface_backend_address_pool_association" "ilb_internal" {
  for_each = toset(var.vmss_internal_nic_ids)

  network_interface_id    = each.value
  ip_configuration_name   = "internal-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.ilb.id
}

# ============================================
# EXTERNAL LOAD BALANCER (OPTIONAL)
# ============================================

resource "azurerm_public_ip" "external_lb" {
  count               = var.enable_external_lb ? 1 : 0
  name                = "${var.project_name}-ext-lb-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.common_tags
}

resource "azurerm_lb" "external" {
  count               = var.enable_external_lb ? 1 : 0
  name                = "${var.project_name}-ext-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  tags                = var.common_tags

  frontend_ip_configuration {
    name                 = "external-frontend"
    public_ip_address_id = azurerm_public_ip.external_lb[0].id
  }
}

resource "azurerm_lb_backend_address_pool" "external" {
  count           = var.enable_external_lb ? 1 : 0
  loadbalancer_id = azurerm_lb.external[0].id
  name            = "${var.project_name}-ext-backend-pool"
}

resource "azurerm_lb_probe" "external" {
  count           = var.enable_external_lb ? 1 : 0
  loadbalancer_id = azurerm_lb.external[0].id
  name            = "${var.project_name}-ext-health-probe"
  protocol        = var.external_health_probe_protocol
  port            = var.external_health_probe_port
  request_path    = var.external_health_probe_path
  interval_in_seconds = var.external_health_probe_interval
  number_of_probes = var.external_health_probe_unhealthy_threshold
}

resource "azurerm_lb_rule" "external" {
  for_each = var.enable_external_lb ? var.external_lb_rules : {}

  loadbalancer_id                = azurerm_lb.external[0].id
  name                           = "${var.project_name}-ext-rule-${each.key}"
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  frontend_ip_configuration_name = "external-frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.external[0].id]
  probe_id                       = azurerm_lb_probe.external[0].id
  idle_timeout_in_minutes        = var.external_lb_idle_timeout
}

resource "azurerm_network_interface_backend_address_pool_association" "external" {
  for_each = var.enable_external_lb ? toset(var.vmss_external_nic_ids) : toset([])

  network_interface_id    = each.value
  ip_configuration_name   = "external-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.external[0].id
}
