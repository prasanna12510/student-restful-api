output "managed_policy_arn" {
  value = aws_iam_role_policy_attachment.managed_policy_attachment.*.id
}
