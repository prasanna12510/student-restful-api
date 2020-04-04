####################################################################  VARIABLES  #####################################################
data "terraform_remote_state" "student-service_infra_state" {
  backend = "remote"
  config = {
    organization = "terracloud-utility"
    token        = "TF_CLOUD_TOKEN"
    workspaces = {
      name = "student-service-infra-${terraform.workspace}"
    }
  }
}

data "aws_caller_identity" "current" {}


#create task_definition
module "student-api-task-definition" {
  source                       = "../../modules/terraform/aws/ecs/task_definition"
  task_definition_name         = local.task_definition_name
  container_name               = var.container_name
  container_image              = local.container_image
  container_memory_reservation = var.container_memory_reservation
  container_cpu                = var.container_cpu
  secrets                      = local.container_secrets
  port_mappings                = var.port_mappings
  log_configuration            = local.log_configuration
  repository_credentials       = local.repository_credentials
  ulimits                      = var.ulimits
  ecs_task_role                = data.terraform_remote_state.student-service_infra_state.outputs.ecs_task_role_arn
  ecs_task_execution_role      = data.terraform_remote_state.student-service_infra_state.outputs.ecs_task_execution_role_arn
  tags                         = local.tags
}

#create ECS service definition
module "student-api-ecs-service" {
  source                             = "../../modules/terraform/aws/ecs/service"
  service_name                       = local.service_name
  deployment_maximum_percent         = local.deployment_maximum_percent
  deployment_minimum_healthy_percent = local.deployment_minimum_healthy_percent
  ecs_service_role                   = data.terraform_remote_state.student-service_infra_state.outputs.ecs_service_role_name
  task_definition                    = module.student-api-task-definition.ecs_task_definition_latest
  desired_count                      = var.desired_count
  cluster_name                       = data.terraform_remote_state.student-service_infra_state.outputs.ecs_cluster_name
  ecs_load_balancers                 = local.ecs_load_balancers
  scheduling_strategy                = var.scheduling_strategy
}

## service autoscaling and setting scale up and scale down step scaling
module "student-api-ecs-service-autoscaling" {
  source                       = "../../modules/terraform/aws/autoscaling/autoscaling_policy/ecs_service_scaling"
  enabled                      = true
  min_capacity                 = local.min_capacity
  max_capacity                 = local.max_capacity
  role_arn                     = data.terraform_remote_state.student-service_infra_state.outputs.ecs_service_role_arn
  cluster_name                 = data.terraform_remote_state.student-service_infra_state.outputs.ecs_cluster_name
  service_name                 = ecs_service_name
  adjustment_type              = var.autoscaling_policy_adjustment_type
  metric_aggregation_type      = var.autoscaling_policy_metric_aggregation_type
  scaleup_policy_name          = "${module.student-api-ecs-service.ecs_service}-scale-up"
  step_scale_up_adjustments    = local.scale_up_adjustments
  scale_up_cooldown            = var.autoscaling_policy_scaleup_cooldown
  scaledown_policy_name        = "${module.student-api-ecs-service.ecs_service}-scale-down"
  step_scale_down_adjustments  = local.scale_down_adjustments
  scale_down_cooldown          = var.autoscaling_policy_scaledown_cooldown
}


### ECS service cloudwatch_alarm for scaleup actions
module "cloudwatch_alarm_ecs_service_scaleup" {
  source              = "../../../modules/terraform/aws/cloudwatch/alarm"
  evaluation_periods  = 1
  period              = "120"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  metric_name         = "CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = 60
  alarm_description   = "This alarm monitors ${module.student-api-ecs-service.ecs_service} containers CPU utilization for scaling up"
  alarm_actions       = ["${module.student-api-ecs-service-autoscaling.scale_up_policy_arn}"]
  alarm_name          = "${module.student-api-ecs-service.ecs_service}-containers-CPU-Utilization-Above-60"
  datapoints_to_alarm = "1"
  dimensions          = local.ecs_dimensions_map
}

### ECS service cloudwatch_alarm for scaledown actions
module "cloudwatch_alarm_ecs_service_scaledown" {
  source              = "../../../modules/terraform/aws/cloudwatch/alarm"
  evaluation_periods  = 1
  period              = "120"
  namespace           = "AWS/ECS"
  statistic           = "Average"
  metric_name         = "CPUUtilization"
  comparison_operator = "LessThanThreshold"
  threshold           = 30
  alarm_description   = "This alarm monitors ${module.student-api-ecs-service.ecs_service} containers CPU utilization for scaling down"
  alarm_actions       = ["${module.student-api-ecs-service-autoscaling.scale_down_policy_arn}"]
  alarm_name          = "${module.student-api-ecs-service.ecs_service}-containers-CPU-Utilization-Below-30"
  datapoints_to_alarm = "1"
  dimensions          = local.ecs_dimensions_map
}

######################################################  OUTPUTS  #####################################################
output "ecs_container_definition_json" {
  value = module.student-api-task-definition.container_definition_json
}

output "ecs_task_definition_arn" {
  value = module.student-api-task-definition.ecs_task_definition_arn
}

output "ecs_service_name" {
  value = module.student-api-ecs-service.ecs_service
}

output "ecs_service_autoscaling_target_id" {
  value = module.student-api-ecs-service-autoscaling.ecs_autoscaling_target_id
}

output "ecs_service_autoscaling_policy_scale_up_arn" {
  value = module.student-api-ecs-service-autoscaling.scale_up_policy_arn
}

output "ecs_service_autoscaling_policy_scale_down_arn" {
  value = module.student-api-ecs-service-autoscaling.scale_down_policy_arn
}

output "cloudwatch_ecs_service_scaleup_cpuutilization_alarm" {
  value = module.cloudwatch_alarm_ecs_service_scaleup.cloudwatch_metric_alarm_arn
}

output "cloudwatch_ecs_service_scaledown_cpuutilization_alarm" {
  value = module.cloudwatch_alarm_ecs_service_scaledown.cloudwatch_metric_alarm_arn
}
