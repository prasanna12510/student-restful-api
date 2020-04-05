resource "aws_alb" "application" {
  count = var.create_alb  ? 1 : 0
  load_balancer_type               = "application"
  name                             = var.lb_name
  internal                         = var.is_internal
  security_groups                  = [var.security_groups]
  subnets                          = var.subnets
  idle_timeout                     = var.idle_timeout
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
  enable_deletion_protection       = var.enable_deletion_protection
  enable_http2                     = var.enable_http2
  ip_address_type                  = var.ip_address_type
  tags = merge(
  var.tags,
  {
    "Name" = var.name
  },
  )

  access_logs {
    bucket  = var.log_bucket_name
    prefix  = "alb-acesslogs/${var.service}/${var.environment}"
    enabled = true
  }

  timeouts {
    create = var.load_balancer_create_timeout
    delete = var.load_balancer_delete_timeout
    update = var.load_balancer_update_timeout
  }

}
