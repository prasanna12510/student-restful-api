################### Elastic IP ###################

resource "aws_eip" "eip" {
  count = 1
  vpc   = true
  tags = merge(

    {"Name" = format("%s", var.name)},

    var.tags,
  )
}

################### NAT GATEWAY ###################

resource "aws_nat_gateway" "nat" {
  count         = 1
  subnet_id     = element(var.public_subnet_ids, count.index,)
  allocation_id = element(aws_eip.eip.*.id, count.index)
  tags = merge(

    {"Name" = format("%s", var.name)},

    var.tags,
  )
}
