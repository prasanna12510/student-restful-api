output "sns_topic_subscription_arn" {
  description = "The ARN of the sns topic subscription."
  value       = element(concat(aws_sns_topic_subscription.main.*.arn, [""]), 0)
}
