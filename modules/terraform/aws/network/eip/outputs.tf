output "eip-ids" {
  value = aws_eip.nat_ip.*.id
}

output "nat_public_ips" {
  value = aws_eip.nat_ip.*.public_ip
}