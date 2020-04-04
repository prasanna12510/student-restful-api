output "dashboard_arn" {
  value = element(concat(aws_cloudwatch_dashboard.main.*.dashboard_arn, [""]), 0)
}
