data "aws_vpc_endpoint_service" "s3" {
  service = var.service_name
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = data.aws_vpc_endpoint_service.s3.service_name
  vpc_endpoint_type = var.end_point_type
    tags = merge(

    { "Name" = format("%s", var.name) },

    var.tags,

  )
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = var.private_routetable_id[0]
}
