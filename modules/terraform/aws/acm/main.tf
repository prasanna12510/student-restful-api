data "aws_route53_zone" "zone" {
  name         = var.hosted_zone_name
  private_zone = "false"
}

resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name          = var.certificate_name
    ProductDomain = var.product_domain
    Environment   = var.environment
    Description   = var.description
    ManagedBy     = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "this" {
  name    = aws_acm_certificate.this.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.this.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = ["${aws_acm_certificate.this.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
  allow_overwrite = var.validation_allow_overwrite_records

  depends_on = [aws_acm_certificate.this]
}

resource "aws_acm_certificate_validation" "dns_validation" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = ["${aws_route53_record.this.fqdn}"]
}
