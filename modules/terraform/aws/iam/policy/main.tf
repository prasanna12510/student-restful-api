resource "aws_iam_policy" "policy" {
  name        = var.iam_policy_name
  path        = var.iam_policy_path
  policy      = var.iam_policy_data
}
