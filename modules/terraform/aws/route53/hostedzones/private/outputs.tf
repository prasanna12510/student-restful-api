output "domain_name" {
  value = aws_route53_zone.private_domain.*.name
}
output "hosted_zone_id" {
  value = concat(aws_route53_zone.private_domain.*.id, [""])[0]
}
output "hostedzoneid" {
  value = concat(aws_route53_zone_association.secondary.*.id, [""])[0]
}
