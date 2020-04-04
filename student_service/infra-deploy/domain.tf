data "aws_route53_zone" "dns_zone" {
  name         = "${var.hosted_zone_name}." # Notice the dot!!!
  private_zone = false
}

######################################################  RESOURCES  #####################################################
module "student_service_route53_record" {
  source          = "../../modules/terraform/aws/route53/recordsets"
  zone_id         = data.aws_route53_zone.dns_zone.zone_id
  aliases         = [var.service_name]
  target_zone_id  = module.alb.alb_zone_id
  target_dns_name = module.alb.alb_dnsname
  is_A_record     = true
}

#######################################################  OUTPUTS #######################################################

output "student_service_domain" {
  value = "${module.student_service_route53_record.dns_record_name}.${terraform.workspace}-hooq.tv"

}
