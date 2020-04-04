resource "aws_appautoscaling_policy" "main" {
  name               = var.name
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace

  step_scaling_policy_configuration {
    cooldown                = var.cooldown
    metric_aggregation_type = var.metric_aggregation_type
    adjustment_type         = var.adjustment_type


    dynamic "step_adjustment" {
    for_each = var.step_scale_adjustments
    content {
      scaling_adjustment = lookup(step_adjustment.value ,"scaling_adjustment", null)
      metric_interval_lower_bound = lookup(step_adjustment.value, "lower_bound",null)
      metric_interval_upper_bound = lookup(step_adjustment.value, "upper_bound",null)
    }
  }

  }
}
