##################################SNS Topic and Subscription######################
module "sns_topic" {
  source  = "../../modules/terraform/aws/sns/topic"
  create_topic = true
  name         = local.topic_name
  display_name = local.topic_name
  tags         = local.tags
}

module "sns_topic_subscription" {
  source  = "../../modules/terraform/aws/sns/subscription"
  create_subscription = true
  topic_arn           = module.sns_topic.sns_topic_arn
  protocol            = "lambda"
  endpoint            = module.lambda_notify_slack.arn
}

##############################lambda for slack notification######################
module "lambda_notify_slack" {
  source = "../../modules/terraform/aws/lambda/function"
  iam_role_arn           = data.terraform_remote_state.student-service_generic_state.outputs.lambda_notify_role_arn
  bucket_name            = data.terraform_remote_state.student-service_generic_state.outputs.lambda_notify_s3_bucket_name
  bucket_key             = data.terraform_remote_state.student-service_generic_state.outputs.lambda_notify_s3_bucket_key
  runtime                = var.slack_lambda_runtime
  timeout                = var.slack_lambda_timeout
  func_name              = local.lambda_notify_name
  func_handler           = var.slack_lambda_handler_name
  source_code_hash       = data.terraform_remote_state.student-service_generic_state.outputs.lambda_notify_s3_bucket_hash
  description            = var.slack_lambda_function_decsription
  tags                   = local.tags
  environment_variables = {
    ENVIRONMENT       = terraform.workspace
    SLACK_WEBHOOK_URL = var.slack_webhook_url
    SLACK_CHANNEL     = local.slack_channel
    SLACK_USERNAME    = var.slack_username
    SLACK_EMOJI       = var.slack_emoji
    LOG_EVENTS        = var.slack_lambda_log_events
  }
}

#########################SNS trigger to lambda##################################
module  "lambda_notify_slack_permission" {
  source        = "../../modules/terraform/aws/lambda/permission"
  create        = true
  statement_id  = var.slack_lambda_permission.statement_id
  action        = var.slack_lambda_permission.action
  function_name = module.lambda_notify_slack.func_name
  principal     = var.slack_lambda_permission.principal
  source_arn    = module.sns_topic.sns_topic_arn
}

###################HTTP-4xx#############################################################
module  "httpcode_target_4xx_count" {
  source                    = "../../modules/terraform/aws/cloudwatch/alarm"
  create_metric_alarm       = local.target_4xx_alarm_enabled
  alarm_name                = format(var.alarm_name,"${local.name}-httpcode_target_4xx_count")
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["target_4xx_count"]
  namespace                 = "AWS/ApplicationELB"
  period                    = var.period
  statistic                 = var.statistic["target_4xx_count"]
  threshold                 = local.thresholds["target_4xx_count"]
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
  alarm_description         = format(var.httpcode_alarm_description, "4XX",local.name,local.thresholds["target_4xx_count"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.cloudwatch_alarm_notify_arns["alarm_actions"]
  dimensions                = local.target_group_dimensions_map
}
###################HTTP-5xx#############################################################
module "httpcode_target_5xx_count" {
  source                    = "../../modules/terraform/aws/cloudwatch/alarm"
  create_metric_alarm       = local.target_5xx_alarm_enabled
  alarm_name                = format(var.alarm_name,"${local.name}-httpcode_target_5xx_count")
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["target_5xx_count"]
  namespace                 = "AWS/ApplicationELB"
  period                    = var.period
  statistic                 = var.statistic["target_5xx_count"]
  threshold                 = local.thresholds["target_5xx_count"]
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
  alarm_description         = format(var.httpcode_alarm_description, "5XX", local.name, local.thresholds["target_5xx_count"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.cloudwatch_alarm_notify_arns["alarm_actions"]
  dimensions                = local.target_group_dimensions_map
}

###################ALB-HTTP-5xx#############################################################
module  "httpcode_elb_5xx_count" {
  source                    = "../../modules/terraform/aws/cloudwatch/alarm"
  create_metric_alarm       = local.elb_5xx_alarm_enabled
  alarm_name                = format(var.alarm_name,"${local.name}-httpcode_elb_5xx_count")
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["elb_5xx_count"]
  namespace                 = "AWS/ApplicationELB"
  period                    = var.period
  statistic                 = var.statistic["elb_5xx_count"]
  threshold                 = local.thresholds["elb_5xx_count"]
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
  alarm_description         = format(var.httpcode_alarm_description, "ELB-5XX", local.name, local.thresholds["elb_5xx_count"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.cloudwatch_alarm_notify_arns["alarm_actions"]
  dimensions                = local.load_balancer_dimensions_map
}
###################Target-UnhealthyHost#############################################################
module  "target_unhealthy_hosts" {
  source                    = "../../modules/terraform/aws/cloudwatch/alarm"
  create_metric_alarm       = local.target_unhealthy_hosts_alarm_enabled
  alarm_name                = format(var.alarm_name,"${local.name}-target_unhealthy_hosts")
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["target_unhealthy_hosts"]
  namespace                 = "AWS/ApplicationELB"
  period                    = var.period
  statistic                 = var.statistic["target_unhealthy_hosts"]
  threshold                 = local.thresholds["target_unhealthy_hosts"]
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
  alarm_description         = format(var.httpcode_alarm_description, "unhealthy_host_count", local.name, local.thresholds["elb_5xx_count"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.cloudwatch_alarm_notify_arns["alarm_actions"]
  dimensions                = local.load_balancer_dimensions_map
}

###################Target-ResponseTime#############################################################
module "target_response_time_average" {
  source                    = "../../modules/terraform/aws/cloudwatch/alarm"
  create_metric_alarm       = local.target_response_time_alarm_enabled
  alarm_name                = format(var.alarm_name,"${local.name}-target_response_time_average")
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["target_response_time"]
  namespace                 = "AWS/ApplicationELB"
  period                    = var.period
  statistic                 = var.statistic["target_response_time"]
  threshold                 = local.thresholds["target_response_time"]
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
  alarm_description         = format(var.target_response_time_alarm_description, local.name, local.thresholds["target_response_time"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.cloudwatch_alarm_notify_arns["alarm_actions"]
  dimensions                = local.target_group_dimensions_map
}

###################ECS-HighCPU#############################################################
module "ecs_high_cpu" {
  source                    = "../../modules/terraform/aws/cloudwatch/alarm"
  create_metric_alarm       = local.ecs_high_cpu_enabled
  alarm_name                = format(var.alarm_name,"${local.name}-highcpu-above80")
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["ecs_high_cpu"]
  namespace                 = "AWS/ECS"
  period                    = var.period
  statistic                 = var.statistic["ecs_high_cpu"]
  threshold                 = local.thresholds["ecs_high_cpu"]
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
  alarm_description         = format(var.utlization_alarm_description, "HighCPU_Utilization",local.name, local.thresholds["ecs_high_cpu"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.cloudwatch_alarm_notify_arns["alarm_actions"]
  dimensions                = local.ecs_dimensions_map
}

###################ECS-LowCPU#############################################################
module "ecs_low_cpu" {
  source                    = "../../modules/terraform/aws/cloudwatch/alarm"
  create_metric_alarm       = local.ecs_high_cpu_enabled
  alarm_name                = format(var.alarm_name,"${local.name}-lowcpu-40")
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["ecs_low_cpu"]
  namespace                 = "AWS/ECS"
  period                    = var.period
  statistic                 = var.statistic["ecs_low_cpu"]
  threshold                 = local.thresholds["ecs_low_cpu"]
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
  alarm_description         = format(var.utlization_alarm_description, "LowCPU_Utilization",local.name, local.thresholds["ecs_low_cpu"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.cloudwatch_alarm_notify_arns["alarm_actions"]
  dimensions                = local.ecs_dimensions_map
}


###################ECS-HighMemory#############################################################
module "ecs_high_memory" {
  source                    = "../../modules/terraform/aws/cloudwatch/alarm"
  create_metric_alarm       = local.ecs_high_memory_enabled
  alarm_name                = format(var.alarm_name,"${local.name}-highmem-above80")
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["ecs_high_memory"]
  namespace                 = "AWS/ECS"
  period                    = var.period
  statistic                 = var.statistic["ecs_high_memory"]
  threshold                 = local.thresholds["ecs_high_memory"]
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
  alarm_description         = format(var.utlization_alarm_description, "HighMEM_Utilization",local.name, local.thresholds["ecs_high_memory"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.cloudwatch_alarm_notify_arns["alarm_actions"]
  dimensions                = local.ecs_dimensions_map
}

###################ECS-LowMemory#############################################################
module "ecs_low_memory" {
  source                    = "../../modules/terraform/aws/cloudwatch/alarm"
  create_metric_alarm       = local.ecs_low_memory_enabled
  alarm_name                = format(var.alarm_name,"${local.name}-lowmem-below40")
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["ecs_low_memory"]
  namespace                 = "AWS/ECS"
  period                    = var.period
  statistic                 = var.statistic["ecs_low_memory"]
  threshold                 = local.thresholds["ecs_low_memory"]
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
  alarm_description         = format(var.utlization_alarm_description, "LowMEM_Utilization",local.name, local.thresholds["ecs_low_memory"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.cloudwatch_alarm_notify_arns["alarm_actions"]
  dimensions                = local.ecs_dimensions_map
}

###################ASG-SystemFailure#############################################################
module "asg_sys_check_failure" {
  source                    = "../../modules/terraform/aws/cloudwatch/alarm"
  create_metric_alarm       = local.asg_sys_check_failure_enabled
  alarm_name                = format(var.alarm_name,"${local.name}-ec2-syscheck-failure")
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.evaluation_periods
  metric_name               = var.metric_name["asg_sys_check_failure"]
  namespace                 = "AWS/EC2"
  period                    = var.period
  statistic                 = var.statistic["asg_sys_check_failure"]
  threshold                 = local.thresholds["asg_sys_check_failure"]
  treat_missing_data        = var.treat_missing_data
  datapoints_to_alarm       = var.datapoints_to_alarm
  alarm_description         = format(var.utlization_alarm_description, "syscheckfailure",local.name, local.thresholds["asg_sys_check_failure"], var.period / 60, var.evaluation_periods)
  alarm_actions             = local.cloudwatch_alarm_notify_arns["alarm_actions"]
  dimensions                = local.asg_dimensions_map
}

############################outputs for cloudwatch alarm#######################

output "cloudwatch_httpcode_target_4xx_count_alarm" {
  value = module.httpcode_target_4xx_count.cloudwatch_metric_alarm_arn
}

output "cloudwatch_httpcode_target_5xx_count_alarm" {
  value = module.httpcode_target_5xx_count.cloudwatch_metric_alarm_arn
}

output "cloudwatch_httpcode_elb_5xx_count_alarm" {
  value = module.httpcode_elb_5xx_count.cloudwatch_metric_alarm_arn
}

output "cloudwatch_target_unhealthy_hosts_alarm" {
  value = module.target_unhealthy_hosts.cloudwatch_metric_alarm_arn
}

output "cloudwatch_target_response_time_average_alarm" {
  value = module.target_response_time_average.cloudwatch_metric_alarm_arn
}

output "high_cpu_utlization_alarm" {
  value = module.ecs_high_cpu.cloudwatch_metric_alarm_arn
}

output "low_cpu_utlization_alarm" {
  value = module.ecs_low_cpu.cloudwatch_metric_alarm_arn
}

output "high_memory_utlization_alarm" {
  value = module.ecs_high_memory.cloudwatch_metric_alarm_arn
}

output "low_memory_utlization_alarm" {
  value = module.ecs_low_memory.cloudwatch_metric_alarm_arn
}

output "lambda_slack_notify_arn" {
  value = module.lambda_notify_slack.arn
}

output "sns_topic_slack_notify_arn" {
  value = module.sns_topic.sns_topic_arn
}
