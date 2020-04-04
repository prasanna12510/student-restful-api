resource "aws_security_group" "sg" {
  name        = "${var.name}-sg"
  description = "security group for ${var.name}"
  vpc_id      = var.vpc_id
  egress {

    from_port   = var.any_port
    to_port     = var.any_port
    protocol    = var.any_protocol
    cidr_blocks = var.all_ips

  }

  tags = merge(

    { "Name" = format("%s", var.name) },

    var.tags,

  )
  lifecycle { create_before_destroy = true }
}
