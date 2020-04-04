resource "aws_alb_listener" "https" {
  count = var.https_tcp_listeners_count
  load_balancer_arn = element(concat(var.alb_arn, [""]), 0)
  port = lookup(element(var.https_tcp_listeners, count.index), "port")
  protocol = lookup(element(var.https_tcp_listeners, count.index), "protocol")
  ssl_policy =  var.ssl_policy
  certificate_arn =  var.certificate_arn
  default_action {
    target_group_arn = var.tg_arn
    type             = "forward"
  }
  lifecycle {
    create_before_destroy = true
  }
}
