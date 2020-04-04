resource "aws_lb_listener_certificate" "main" {
  count  = var.alb_additional_certificate_count
  certificate_arn = var.certificate_arn
  listener_arn = var.listener_arn
}
