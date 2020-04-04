
output "sns_topic_name" {
  description = "The ARN of the sns topic subscription."
  value       = element(concat(aws_sns_topic.main.*.name, [""]), 0)
}


output "sns_topic_arn" {
  description = "The ARN of the sns topic subscription."
  value       = element(concat(aws_sns_topic.main.*.arn, [""]), 0)
}
