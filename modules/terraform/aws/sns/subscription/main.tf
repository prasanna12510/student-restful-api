resource "aws_sns_topic_subscription" "main" {
  count = var.create_subscription

  topic_arn = var.topic_arn
  protocol  = var.protocol
  endpoint  = var.endpoint
}
