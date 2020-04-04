resource "aws_alb_listener" "http" {
  count             = length(var.http_tcp_listeners)
  load_balancer_arn = element(concat(var.alb_arn, [""]), 0)
  port              = lookup(element(var.http_tcp_listeners, count.index), "port")
  protocol          = lookup(element(var.http_tcp_listeners, count.index), "protocol")

  // var.default_action == "redirect-to-https"
  // Redirect requests to https listener
  dynamic "default_action" {
    for_each = var.default_action == "redirect-to-https" ? [1] : []
    content {
      type = "redirect"

      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  // var.default_action == "forward"
  // Forward requests to the provided target group arn
  dynamic "default_action" {
    for_each = var.default_action == "forward" ? [1] : []
    content {
      type             = "forward"
      target_group_arn = var.default_tg_arn
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
