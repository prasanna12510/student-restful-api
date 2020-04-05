#######################################################  Locals  #######################################################

locals {
  name                = "${var.service_name}-${terraform.workspace}"
  cidr                = var.env[terraform.workspace].cidr
  private_subnets     = "${split(",", var.env[terraform.workspace].cidrs_private)}"
  public_subnets      = "${split(",", var.env[terraform.workspace].cidrs_public)}"
  max_subnet_length   = max(length(local.private_subnets), )
  host_header_listener_rule= ["${var.service_name}.${var.hosted_zone_name}"]
  path_pattern_listener_rules = [
    {
      path_pattern_values = "/students/*"
    }
  ]

  tags = {
    service_name = var.service_name
    owner        = var.owner
    environment  = terraform.workspace
    version      = var.tag
  }

  target_groups = [
    {
      "name"                             = "${local.name}-port80"
      "backend_protocol"                 = "HTTP"
      "backend_port"                     = 80
      "slow_start"                       = 0
      "backend_path"                     = "/students/health"
      "target_type"                      = "instance"
    }
  ]

  http_tcp_listeners = [
    {
      "port"     = 80
      "protocol" = "HTTP"
    }
  ]

  https_tcp_listeners = [
    {
      "port"     = 443
      "protocol" = "HTTPS"
    }
  ]

  ec2_root_volume_size = var.env[terraform.workspace].ec2_root_volume_size
  ec2_instance_type    = var.env[terraform.workspace].ec2_instance_type
  log_name_map = {
    docker     = "${local.name}/var/log/docker"
    monitoring = "${local.name}-logs"
    dmesg      = "${local.name}/var/log/dmesg"
    ecs-init   = "${local.name}/var/log/ecs/ecs-init.log"
    ecs-agent  = "${local.name}/var/log/ecs/ecs-agent.log"
    audit      = "${local.name}/var/log/ecs/audit.log"
    messages   = "${local.name}/var/log/messages"
  }


  alb_sg_ingress_rules = [
    {
      "description" = "ALLOW HTTP"
      "from_port"   = "80"
      "to_port"     = "80"
      "protocol"    = "tcp"
      "cidr_blocks" = "0.0.0.0/0"
    },
    {
      "description" = "ALLOW HTTPs"
      "from_port"   = "443"
      "to_port"     = "443"
      "protocol"    = "tcp"
      "cidr_blocks" = "0.0.0.0/0"
    }
  ]

  asg_sg_ingress_rules = [
    {
      "description" = "ALLOW ALL PORTS INSIDE VPC CIDR"
      "from_port"   = "${var.any_port}"
      "to_port"     = "${var.to_port}"
      "protocol"    = "tcp"
      "cidr_blocks" = "${local.cidr}"
    }
  ]
}

##cloudwatch alarms for slack notification
locals{

  topic_name                   = "${local.name}-${var.env[terraform.workspace].sns_topic_name}"
  lambda_notify_name           = "${local.name}-${var.env[terraform.workspace].lambda_name}"
  slack_channel                =  var.env[terraform.workspace].slack_channel_name

  cloudwatch_alarm_notify_arns = {
    alarm_actions             = [module.sns_topic.sns_topic_arn]
    ok_actions                = []
    insufficient_data_actions = []
  }

  thresholds = {
    target_4xx_count       = max(var.target_4xx_count_threshold, 0)
    target_5xx_count       = max(var.target_5xx_count_threshold, 0)
    elb_5xx_count          = max(var.elb_5xx_count_threshold, 0)
    target_response_time   = max(var.target_response_time_threshold, 0)
    target_unhealthy_hosts = max(var.target_unhealthy_hosts_threshold, 0)
    ecs_high_cpu           = max(var.ecs_high_cpu_threshold,0)
    ecs_low_cpu            = max(var.ecs_low_cpu_threshold,0)
    ecs_high_memory        = max(var.ecs_high_memory_threshold,0)
    ecs_low_memory         = max(var.ecs_low_memory_threshold,0)
    asg_sys_check_failure  = max(var.asg_sys_check_failure_threshold,0)
  }


  target_4xx_alarm_enabled             =  var.target_4xx_count_threshold > 0
  target_5xx_alarm_enabled             =  var.target_5xx_count_threshold > 0
  elb_5xx_alarm_enabled                =  var.elb_5xx_count_threshold > 0
  target_response_time_alarm_enabled   =  var.target_response_time_threshold > 0
  target_unhealthy_hosts_alarm_enabled =  var.target_unhealthy_hosts_threshold > 0
  ecs_high_cpu_enabled                 =  var.ecs_high_cpu_threshold > 0
  ecs_low_cpu_enabled                  =  var.ecs_low_cpu_threshold > 0
  ecs_high_memory_enabled              =  var.ecs_high_memory_threshold > 0
  ecs_low_memory_enabled               =  var.ecs_low_memory_threshold > 0
  asg_sys_check_failure_enabled        =  var.asg_sys_check_failure_threshold > 0


  target_group_dimensions_map = {
    TargetGroup  = module.alb_targetgroups.target_group_arn_suffix
    LoadBalancer = module.alb.alb_arn_suffix
  }

  load_balancer_dimensions_map = {
    LoadBalancer = module.alb.alb_arn_suffix
  }

  asg_dimensions_map = {
    AutoScalingGroupName = module.autoscaling_group.aws_asg_name
  }

  ecs_dimensions_map = {
    ClusterName = module.ecs_cluster.ecs_cluster_name
  }

}
