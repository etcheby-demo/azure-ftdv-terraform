# ============================================
# NETWORK SECURITY GROUPS
# ============================================

resource "azurerm_network_security_group" "external" {
  name                = "${var.project_name}-ftdv-ext-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags

  security_rule {
    name                       = "AllowInboundHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowInboundHTTPS"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.management_source_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowInternalVNetTraffic"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = var.allowed_internal_cidrs
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                   = "AllowOutbound"
    priority               = 100
    direction              = "Outbound"
    access                 = "Allow"
    protocol               = "*"
    source_port_range      = "*"
    destination_port_range = "*"
    source_address_prefix  = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "internal" {
  name                = "${var.project_name}-ftdv-int-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags

  security_rule {
    name                       = "AllowInternalVNetTraffic"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = var.allowed_internal_cidrs
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.management_source_ip
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                   = "AllowOutbound"
    priority               = 100
    direction              = "Outbound"
    access                 = "Allow"
    protocol               = "*"
    source_port_range      = "*"
    destination_port_range = "*"
    source_address_prefix  = "*"
    destination_address_prefix = "*"
  }
}

# ============================================
# ASSOCIATE NSGs WITH SUBNETS
# ============================================

resource "azurerm_subnet_network_security_group_association" "external" {
  subnet_id                 = var.external_subnet_id
  network_security_group_id = azurerm_network_security_group.external.id
}

resource "azurerm_subnet_network_security_group_association" "internal" {
  subnet_id                 = var.internal_subnet_id
  network_security_group_id = azurerm_network_security_group.internal.id
}

# ============================================
# ROUTE TABLES (UDRs)
# ============================================

resource "azurerm_route_table" "external" {
  name                = "${var.project_name}-external-rt"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

resource "azurerm_route_table" "internal" {
  name                = "${var.project_name}-internal-rt"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.common_tags
}

# ============================================
# EXTERNAL SUBNET ROUTES
# ============================================

resource "azurerm_route" "external_default" {
  count                  = var.enable_external_default_route ? 1 : 0
  name                   = "default-route"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.external.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = var.external_default_route_next_hop_type
  next_hop_in_ip_address = var.external_default_route_next_hop_type == "VirtualAppliance" ? var.external_default_route_next_hop_ip : null
}

resource "azurerm_route" "external_custom" {
  for_each = var.external_custom_routes

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.external.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_ip : null
}

# ============================================
# INTERNAL SUBNET ROUTES
# ============================================

resource "azurerm_route" "internal_default" {
  count                  = var.enable_internal_default_route ? 1 : 0
  name                   = "default-route"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.internal.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = var.internal_default_route_next_hop_type
  next_hop_in_ip_address = var.internal_default_route_next_hop_type == "VirtualAppliance" ? var.internal_default_route_next_hop_ip : null
}

resource "azurerm_route" "internal_custom" {
  for_each = var.internal_custom_routes

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.internal.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_type == "VirtualAppliance" ? each.value.next_hop_ip : null
}

# ============================================
# ASSOCIATE ROUTE TABLES WITH SUBNETS
# ============================================

resource "azurerm_subnet_route_table_association" "external" {
  subnet_id      = var.external_subnet_id
  route_table_id = azurerm_route_table.external.id
}

resource "azurerm_subnet_route_table_association" "internal" {
  subnet_id      = var.internal_subnet_id
  route_table_id = azurerm_route_table.internal.id
}
