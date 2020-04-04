output "vpc_interface_endpoint_for_ecr_api" {
  value = aws_vpc_endpoint.ecr_api.*.id
}

output "vpc_interface_endpoint_for_ecr_dkr" {
  value = aws_vpc_endpoint.ecr_dkr.*.id
}