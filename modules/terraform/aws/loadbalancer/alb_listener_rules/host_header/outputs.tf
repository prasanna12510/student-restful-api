output "host_header_http_listener_rules" {
  #value = aws_alb_listener_rule.main.*.listener_arn

  value = {
  for listener in aws_alb_listener_rule.main:
  listener.arn => listener.arn
  }

}
