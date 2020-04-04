################### Internet Gateway ###################

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = var.vpc_id
  tags = merge(

  { "Name" = format("%s", var.name) },

  var.tags,

  )
}
