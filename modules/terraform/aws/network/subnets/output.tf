output "subnet_ids" {
  value = aws_subnet.subnets.*.id
}
