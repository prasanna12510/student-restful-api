resource "aws_alb_listener_rule" "main" {
  count = var.path_pattern_listener_count
  listener_arn = element(concat(var.http_listener_arn, [""]), 0)
  action {
    type = "forward"
    target_group_arn = element(concat(var.tg_arn, [""]), 0)
  }
  condition {
    field = "path-pattern"
    values = ["${var.path_pattern_listener_rules[count.index].path_pattern_values}"]
  }
}