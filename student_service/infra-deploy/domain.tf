data "aws_route53_zone" "main" {
  name         = "${local.domainname}." # Notice the dot!!!
  private_zone = false
}

######################################################  RESOURCES  #####################################################
module "student_service_route53_record" {
  source          = "../../../modules/terraform/aws/route53/recordsets/v2.0"
  zone_id         = data.aws_route53_zone.main.zone_id
  aliases         = [var.service_name]
  zone_id         = local.private_hostedzone_id
  target_zone_id  = module.alb.alb_zone_id
  target_dns_name = module.alb.alb_dnsname
  is_A_record     = true
}

#######################################################  OUTPUTS #######################################################

output "student_service_domain" {
  value = "${module.sanctuary_service_route53_record.dns_record_name}.${terraform.workspace}-hooq.vpc"

}
