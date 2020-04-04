output "route_table_id" {
  value = var.attach_natgateway  ? aws_route_table.private_with_ngw.*.id : aws_route_table.private_without_ngw.*.id
}
