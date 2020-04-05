resource "aws_cloudwatch_dashboard" "main" {
  count = var.create_dashboard ? 1 : 0
  dashboard_name = var.dashboard_name
  dashboard_body = var.dashboard_body
}
