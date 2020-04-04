output "vpc_gateway_endpoint_for_s3" {
  value = aws_vpc_endpoint.s3.*.id
}