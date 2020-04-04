################### INTERNAL PRIVATE ROUTES WITH NATGATEWAY ###################

resource "aws_route_table" "private_with_ngw" {
  count  = var.attach_natgateway && var.max_subnet_length > 0 ? 1 : 0
  vpc_id = var.vpc_id
  tags = merge(

    { "Name" = format("%s", var.name) },

    var.tags,

  )
}

resource "aws_route" "nat_routes" {
  count                  = length(var.gateway_id) > 0 && var.attach_natgateway ? 1 : 0
  route_table_id         = element(aws_route_table.private_with_ngw.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(var.gateway_id, count.index)
  timeouts {

    create = "5m"

  }
}

resource "aws_route_table_association" "private_with_ngw" {
  count          = length(var.subnets) > 0 && var.attach_natgateway ? length(var.subnets) : 0
  route_table_id = element(aws_route_table.private_with_ngw.*.id, count.index)
  subnet_id      = element(var.subnet_ids, count.index)
}

################### INTERNAL PRIVATE ROUTES WITHOUT NATGATEWAY ###################

resource "aws_route_table" "private_without_ngw" {
  count  = var.attach_natgateway ? 0 : 1
  vpc_id = var.vpc_id
  tags = merge(

    { "Name" = format("%s", var.name) },

    var.tags,

  )
}

resource "aws_route_table_association" "private_without_ngw" {
  count          = length(var.subnets) > 0 && var.attach_natgateway ? 0 : length(var.subnets)
  route_table_id = element(aws_route_table.private_without_ngw.*.id, count.index)
  subnet_id      = element(var.subnet_ids, count.index)
}
