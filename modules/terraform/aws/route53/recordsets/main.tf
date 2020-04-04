resource "aws_route53_record" "a_type_record" {
  count   = var.is_A_record ? length(compact(var.aliases)) : 0
  zone_id = var.zone_id
  name    = compact(var.aliases)[count.index]
  type    = "A"
  alias {
    name                   = var.target_dns_name
    zone_id                = var.target_zone_id
    evaluate_target_health = var.evaluate_target_health
  }
}

resource "aws_route53_record" "not_a_type_record" {
  count           = var.is_A_record ? 0 : length(var.dns_name_list)
  zone_id         = var.zone_id
  name            = element(var.dns_name_list, count.index)
  type            = var.recordtype
  ttl             = var.ttl
  allow_overwrite = true
  records         = var.dns_value_list
}
