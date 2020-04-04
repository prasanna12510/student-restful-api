output "eip_nat_ids" {
  value = aws_eip.eip.*.id
}

output "eip_nat_ips" {
  value = aws_eip.eip.*.public_ip
}

output "natgw_id" {
  value = aws_nat_gateway.nat.*.id
}
