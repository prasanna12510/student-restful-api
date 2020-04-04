# retrive the zone_id in current aws account
data "aws_route53_zone" "main" {
  name = var.hosted_zone
  private_zone = false
}

module "aws_ssl_certs" {
  source = "../../modules/terraform/aws/acm"
  domainname = var.domain_name
  zone_id  = data.aws_route53_zone.main.zone_id
  subject_alternative_names = var.subject_alternative_names
  wait_for_validation = true # false
  tags = local.tags
}

output "acm_cert_arn" {
  value = module.aws_ssl_certs.acm_certificate_arn
}
