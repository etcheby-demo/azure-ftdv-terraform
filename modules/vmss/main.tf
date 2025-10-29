resource "azurerm_linux_virtual_machine_scale_set" "ftdv" {
  name                = "${var.project_name}-ftdv-vmss"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.ftdv_vmss_sku
  instances           = var.ftdv_instance_count
  tags                = var.common_tags

  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  # External Network Interface (Primary)
  network_interface {
    name                      = "${var.project_name}-ftdv-ext-nic"
    primary                   = true
    network_security_group_id = var.external_nsg_id

    ip_configuration {
      name                                   = "external-ipconfig"
      primary                                = true
      subnet_id                              = var.external_subnet_id
      load_balancer_backend_address_pool_ids = var.external_lb_backend_pool_ids
      public_ip_address {
        name                    = "${var.project_name}-ftdv-pip"
        idle_timeout_in_minutes = 30
      }
    }
  }

  # Internal Network Interface (Secondary)
  network_interface {
    name                      = "${var.project_name}-ftdv-int-nic"
    primary                   = false
    network_security_group_id = var.internal_nsg_id

    ip_configuration {
      name                                   = "internal-ipconfig"
      primary                                = true
      subnet_id                              = var.internal_subnet_id
      load_balancer_backend_address_pool_ids = var.internal_lb_backend_pool_ids
      private_ip_address_version             = "IPv4"
      private_ip_address_allocation          = "Dynamic"
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_type
  }

  source_image_reference {
    publisher = var.ftdv_image_publisher
    offer     = var.ftdv_image_offer
    sku       = var.ftdv_image_sku
    version   = var.ftdv_image_version
  }

  # Plan required for marketplace images
  plan {
    name      = var.ftdv_image_sku
    publisher = var.ftdv_image_publisher
    product   = var.ftdv_image_offer
  }

  upgrade_policy_mode = "Manual"
}
