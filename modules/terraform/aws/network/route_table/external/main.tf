################### EXTERNAL ROUTES ###################

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  route {

    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id[0]

  }

  tags = merge(

    { "Name" = format("%s", var.name) },

    var.tags,

  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.subnets) > 0 ? length(var.subnets) : 0
  route_table_id = element(aws_route_table.public.*.id, count.index)
  subnet_id      = element(var.subnet_ids, count.index)
}
