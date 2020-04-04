locals {
  // Get distinct list of domains and SANs
  distinct_domain_names = length(var.domainname) >0 ? distinct(concat(var.domainname, [for s in var.subject_alternative_names : replace(s, "*.", "")])) : []

  // Copy domain_validation_options for the distinct domain names
  validation_domains = length(var.domainname) >0 ? [for k, v in aws_acm_certificate.main[0].domain_validation_options : tomap(v) if contains(local.distinct_domain_names, v.domain_name)] :[]
}

resource "aws_acm_certificate" "main" {
  count = var.create_certificate && length(var.domainname)>0 ?  length(var.domainname): 0

  domain_name               = element(var.domainname, count.index)
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method



  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  count = var.create_certificate && var.validation_method == "DNS" && var.validate_certificate && length(local.distinct_domain_names)>0 ? length(local.distinct_domain_names) : 0

  zone_id = var.zone_id
  name    = element(local.validation_domains, count.index)["resource_record_name"]
  type    = element(local.validation_domains, count.index)["resource_record_type"]
  ttl     = 60

  records = [
    element(local.validation_domains, count.index)["resource_record_value"]
  ]

  allow_overwrite = var.validation_allow_overwrite_records

  depends_on = [aws_acm_certificate.main]
}

resource "aws_acm_certificate_validation" "main" {
  count = var.create_certificate && var.validation_method == "DNS" && var.validate_certificate && length(var.domainname) >0 ? 1 : 0

  certificate_arn = aws_acm_certificate.main[0].arn

  validation_record_fqdns = aws_route53_record.validation.*.fqdn
}
