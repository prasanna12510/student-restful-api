################### PRIVATE SUBNETS ###################

resource "aws_subnet" "subnets" {
  count             = length(var.subnets_cidr)
  vpc_id            = var.vpc_id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(concat(var.subnets_cidr, [""]), count.index)
  tags = merge(

    { "Name" = "${var.name}" },

    var.tags,

  )
}
