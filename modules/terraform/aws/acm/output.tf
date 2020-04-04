output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = concat(aws_acm_certificate.main.*.arn, [""])[0]
}
