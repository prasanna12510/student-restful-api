/**
 * The log group.
 */
resource "aws_cloudwatch_log_group" "main" {
  for_each = var.log_groups
  name = each.value
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_arn
  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
  )
}
