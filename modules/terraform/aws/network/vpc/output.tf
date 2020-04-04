output "vpc_dhcp_id" {
  value = aws_vpc_dhcp_options.dhcp.id
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "igw_id" {
  value = concat(aws_internet_gateway.internet_gateway.*.id, [""])[0]
}
