##################################################################################
# APPLICATION LOADBALANCER SECURITY-GROUP AND ITS SECURITY GROUP RULES
##################################################################################

module "alb_sg" {
  source       = "../../../modules/terraform/aws/security_groups"
  vpc_id       = module.vpc.vpc_id
  name         = "${local.name}-alb"
  tags         = local.tags
  all_ips      = var.all_ips
  any_port     = var.any_port
  any_protocol = var.any_protocol
  tcp_protocol = var.tcp_protocol
}
module "alb_sg_rules" {
  source              = "../../../modules/terraform/aws/security_group_rules/cidr_range"
  sg_id               = module.alb_sg.sg_id
  type                = "ingress"
  ingress_rules       = local.alb_sg_ingress_rules
  ingress_rules_count = length(local.alb_sg_ingress_rules)
}

##################################################################################
# AUTOSCALINGGROUP(ASG) SECURITY-GROUP AND ITS SECURITY GROUP RULES
##################################################################################

module "autoscalinggroup_sg" {
  source       = "../../../modules/terraform/aws/security_groups"
  vpc_id       = module.vpc.vpc_id
  name         = "${local.name}-autoscalling-group"
  tags         = local.tags
  all_ips      = var.all_ips
  any_port     = var.any_port
  any_protocol = var.any_protocol
  tcp_protocol = var.tcp_protocol
}

module "asg_sg_rules_with_cidr" {
  source              = "../../../modules/terraform/aws/security_group_rules/cidr_range"
  ingress_rules       = local.asg_sg_ingress_rules
  ingress_rules_count = length(local.asg_sg_ingress_rules)
  type                = "ingress"
  sg_id               = module.autoscalinggroup_sg.sg_id
}

module "asg_sg_rules_with_source_sg_id_alb" {
  source              = "../../../modules/terraform/aws/security_group_rules/source_sg_id"
  ingress_rules       = local.asg_sg_ingress_rules
  ingress_rules_count = length(local.asg_sg_ingress_rules)
  sg_id               = module.autoscalinggroup_sg.sg_id
  source_sg_id        = module.alb_sg.sg_id
  type                = "ingress"
}

#######################################################  OUTPUTS #######################################################

output "autoscalinggroup_sg_id" {
  value = module.autoscalinggroup_sg.sg_id
}

output "alb_sg_id" {
  value = module.alb_sg.sg_id
}
