output "path_pattern_http_listener_rules" {
  value = aws_alb_listener_rule.main.*.listener_arn
}