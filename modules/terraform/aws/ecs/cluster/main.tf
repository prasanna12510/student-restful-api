resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.name

  tags = merge(
  { "Name" = format("%s", var.name)},

  var.tags,
  )

  lifecycle {
    create_before_destroy = true
  }

}
