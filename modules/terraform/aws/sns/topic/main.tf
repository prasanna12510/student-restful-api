resource "aws_sns_topic" "main" {
  count        = var.create_topic
  name         = var.name
  display_name = var.display_name
  tags         = var.tags
}
