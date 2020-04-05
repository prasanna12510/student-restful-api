
##############widgets for dashboard######################
module "target_4xx_count_widget" {
  source = "../../modules/terraform/aws/cloudwatch/visualization/widget"
  namespace   = "AWS/ApplicationELB"
  metric_name = var.metric_name["target_4xx_count"]
  dimensions = [
    "TargetGroup, ${module.alb_targetgroups.target_group_name}",
  "LoadBalancer, ${module.alb.alb_name}"]
  period = var.period
  stat   = var.statistic["target_4xx_count"]
  title  = format(var.alarm_name, "${local.name}-target_4xx_count")
  width  = 6
  height = 6
}


module "target_5xx_count_widget" {
  source = "../../modules/terraform/aws/cloudwatch/visualization/widget"
  namespace   = "AWS/ApplicationELB"
  metric_name = var.metric_name["target_5xx_count"]
  dimensions = [
    "TargetGroup, ${module.alb_targetgroups.target_group_name}",
  "LoadBalancer, ${module.alb.alb_name}"]
  period = var.period
  stat   = var.statistic["target_5xx_count"]
  title  = format(var.alarm_name, "${local.name}-target_5xx_count")
  width  = 6
  height = 6
}


module "elb_5xx_count_widget" {
  source = "../../modules/terraform/aws/cloudwatch/visualization/widget"
  namespace   = "AWS/ApplicationELB"
  metric_name = var.metric_name["elb_5xx_count"]
  dimensions  = ["LoadBalancer, ${module.alb.alb_name}"]
  period      = var.period
  stat        = var.statistic["elb_5xx_count"]
  title       = format(var.alarm_name, "${local.name}-elb_5xx_count")
  width       = 6
  height      = 6
}


module "target_unhealthy_hosts_count_widget" {
  source = "../../modules/terraform/aws/cloudwatch/visualization/widget"
  namespace   = "AWS/ApplicationELB"
  metric_name = var.metric_name["target_unhealthy_hosts"]
  dimensions = [
    "TargetGroup, ${module.alb_targetgroups.target_group_name}",
  "LoadBalancer, ${module.alb.alb_name}"]
  period = var.period
  stat   = var.statistic["target_unhealthy_hosts"]
  title  = format(var.alarm_name, "${local.name}-target_unhealthy_hosts_count")
  width  = 6
  height = 6
}


module "target_response_time_widget" {
  source = "../../modules/terraform/aws/cloudwatch/visualization/widget"
  namespace   = "AWS/ApplicationELB"
  metric_name = var.metric_name["target_response_time"]
  dimensions = [
    "TargetGroup, ${module.alb_targetgroups.target_group_name}",
  "LoadBalancer, ${module.alb.alb_name}"]
  period = var.period
  stat   = var.statistic["target_response_time"]
  title  = format(var.alarm_name, "${local.name}-target_response_time")
  width  = 6
  height = 6
}


module "ecs_high_cpu_widget" {
  source = "../../modules/terraform/aws/cloudwatch/visualization/widget"
  namespace   = "AWS/ECS"
  metric_name = var.metric_name["ecs_high_cpu"]
  dimensions  = ["ClusterName, ${module.ecs_cluster.ecs_cluster_name}"]
  period = var.period
  stat   = var.statistic["ecs_high_cpu"]
  title  = format(var.alarm_name, "${local.name}-ecs_high_cpu-above80")
  width  = 6
  height = 6
}


module "ecs_low_cpu_widget" {
  source = "../../modules/terraform/aws/cloudwatch/visualization/widget"
  namespace   = "AWS/ECS"
  metric_name = var.metric_name["ecs_low_cpu"]
  dimensions  = ["ClusterName, ${module.ecs_cluster.ecs_cluster_name}"]
  period = var.period
  stat   = var.statistic["ecs_low_cpu"]
  title  = format(var.alarm_name, "${local.name}-ecs_low_cpu-below40")
  width  = 6
  height = 6
}


module "ecs_high_memory_widget" {
  source = "../../modules/terraform/aws/cloudwatch/visualization/widget"
  namespace   = "AWS/ECS"
  metric_name = var.metric_name["ecs_high_memory"]
  dimensions  = ["ClusterName, ${module.ecs_cluster.ecs_cluster_name}"]
  period = var.period
  stat   = var.statistic["ecs_high_memory"]
  title  = format(var.alarm_name, "${local.name}-ecs_high_memory-above80")
  width  = 6
  height = 6
}


module "ecs_low_memory_widget" {
  source = "../../modules/terraform/aws/cloudwatch/visualization/widget"
  namespace   = "AWS/ECS"
  metric_name = var.metric_name["ecs_low_memory"]
  dimensions  = ["ClusterName, ${module.ecs_cluster.ecs_cluster_name}"]
  period = var.period
  stat   = var.statistic["ecs_low_memory"]
  title  = format(var.alarm_name, "${local.name}-ecs_low_memory-below40")
  width  = 6
  height = 6
}


module "asg_sys_check_failure_widget" {
  source = "../../modules/terraform/aws/cloudwatch/visualization/widget"
  namespace   = "AWS/EC2"
  metric_name = var.metric_name["asg_sys_check_failure"]
  dimensions  = ["AutoScalingGroupName, ${module.autoscaling_group.aws_asg_name}"]
  period = var.period
  stat   = var.statistic["asg_sys_check_failure"]
  title  = format(var.alarm_name, "${local.name}-ec2_syscheck_failure")
  width  = 6
  height = 6
}


##################Merge widgets in dashboard######################
module "dashboard" {
  source = "../../modules/terraform/aws/cloudwatch/visualization/dashboard"
  create_dashboard = true
  dashboard_name   = "${local.name}-cloudwatch-dashboard"
  dashboard_body   = <<EOF
  {
   "widgets": [
       ${module.ecs_high_cpu_widget.widget_json},
       ${module.ecs_low_cpu_widget.widget_json},
       ${module.ecs_high_memory_widget.widget_json},
       ${module.ecs_low_memory_widget.widget_json},
       ${module.asg_sys_check_failure_widget.widget_json}
       ${module.target_4xx_count_widget.widget_json},
       ${module.target_5xx_count_widget.widget_json},
       ${module.elb_5xx_count_widget.widget_json},
       ${module.target_unhealthy_hosts_count_widget.widget_json},
       ${module.target_response_time_widget.widget_json}
   ]
 }
 EOF
}
