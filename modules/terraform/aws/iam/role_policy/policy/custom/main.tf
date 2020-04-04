
resource "aws_iam_policy" "custom_policy" {
  name   = var.iam_custom_policy_name
  path   = "/custom/"
  policy = var.iam_custom_role_policy_data

}

resource "aws_iam_policy_attachment" "attachment" {
  name            = "${var.iam_custom_policy_name}-policy-attachment"
  roles           =  var.role_name
  policy_arn      =  aws_iam_policy.custom_policy.arn
}
