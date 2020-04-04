output "alb_dnsname" {
  description = "The DNS name of the load balancer"
  value       = concat(aws_alb.application.*.dns_name, [""])[0]
}

output "alb_id" {
  description = "The id of the load balancer"
  value       = aws_alb.application.*.id
}

output "alb_zone_id" {
  description = "zone id for load balancer"
  value = concat(aws_alb.application.*.zone_id, [""])[0]
}

output "alb_arn" {
  value = aws_alb.application.*.arn
}

output "alb_name" {
  value = element(concat(aws_alb.application.*.name,[""]), 0)
}

output "alb_arn_suffix" {
  value = element(concat(aws_alb.application.*.arn_suffix,[""]), 0)
}
