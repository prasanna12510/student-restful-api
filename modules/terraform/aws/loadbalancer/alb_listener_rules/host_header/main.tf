resource "aws_alb_listener_rule" "main" {
  count = var.is_hostheader  ? var.host_header_listener_count : 0
  listener_arn = element(concat(var.http_listener_arn, [""]), 0)
  action {
    type             = "forward"
    target_group_arn = var.tg_arn
  }
  condition {
    field  = "host-header"
    values = formatlist("%s",var.host_header_listener_rules[count.index])
  }
}
