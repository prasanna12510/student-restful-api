########################### VPC Endpoint for ECR API ###########################

# TODO need to generalize interface endpoint instead of hardcoding

data "aws_vpc_endpoint_service" "ecr_api" {
  service = "${var.service_name}"
}

resource "aws_vpc_endpoint" "ecr_api" {
  service_name       = data.aws_vpc_endpoint_service.ecr_api.service_name
  vpc_id             = var.vpc_id
  security_group_ids = var.securitygroup_id
  vpc_endpoint_type  = var.vpc_endpoint_type
  subnet_ids         = coalescelist(var.ecr_endpoint_subnet_ids, var.private_subnet_ids)
  tags = merge(

    { "Name" = format("%s", var.name) },

    var.tags,

  )
}
