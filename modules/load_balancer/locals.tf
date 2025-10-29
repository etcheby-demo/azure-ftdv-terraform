locals {
  ilb_name              = "${var.project_name}-ilb"
  ilb_frontend_name     = "internal-frontend"
  ilb_backend_pool_name = "${var.project_name}-ilb-backend-pool"
  ilb_health_probe_name = "${var.project_name}-ilb-health-probe"
  ext_lb_name           = "${var.project_name}-ext-lb"
  ext_lb_pip_name       = "${var.project_name}-ext-lb-pip"
  ext_lb_frontend_name  = "external-frontend"
  ext_lb_backend_name   = "${var.project_name}-ext-backend-pool"
  ext_lb_health_probe   = "${var.project_name}-ext-health-probe"
}
