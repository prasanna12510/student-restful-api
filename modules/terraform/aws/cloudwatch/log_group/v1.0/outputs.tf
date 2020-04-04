
output "loggroup_names" {
  value = {
  for loggroup in aws_cloudwatch_log_group.main:
  loggroup.name => loggroup.arn
  }
}