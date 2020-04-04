################### Elastic IP ###################

resource "aws_eip" "nat_ip" {
  count = var.nat_gateway_count
  vpc        = true
  tags = merge(

  { "Name" = format("%s", var.name) },

  var.tags,
  
  )
}