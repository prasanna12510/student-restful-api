output "igw_id" {
  value = concat(aws_internet_gateway.internet_gateway.*.id, [""])[0]
}
