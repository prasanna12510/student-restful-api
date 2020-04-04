resource "aws_iam_role_policy_attachment" "managed_policy_attachment" {
  count      =  length(var.iam_managed_policy_arns)
  role       =  var.role_name
  policy_arn =  var.iam_managed_policy_arns[count.index]
}
