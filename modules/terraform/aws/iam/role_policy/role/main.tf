resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = var.iam_assume_role_policy_data
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = var.create_instance_role ? 1 : 0
  name  = aws_iam_role.this.name
  role  = aws_iam_role.this.name
  lifecycle {
    create_before_destroy = true
  }
}
