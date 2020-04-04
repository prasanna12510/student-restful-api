
resource "aws_route53_zone" "private_domain" {
  count   = length(var.private_hostedzone) > 0 && var.attach_main_vpc_id ? 1 : 0

  name    = var.private_hostedzone
  vpc {
    vpc_id = var.main_vpc_id
  }
  comment = var.comment
  force_destroy = true

  tags = merge(

  { "Name" = format("%s", var.name) },
  var.tags,
  )
}

resource "aws_route53_zone_association" "secondary" {
  count   = var.attach_secondary_vpc_id ? 1 : 0
  zone_id = var.private_hostedzone_id
  vpc_id  = var.secondary_vpc_id
}
