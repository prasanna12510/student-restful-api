resource "aws_appautoscaling_target" "target" {
  count              = var.enabled ? 1 : 0
  service_namespace  = "ecs"
  role_arn           = var.role_arn
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  depends_on         = [var.service_name]
}

resource "aws_appautoscaling_policy" "up" {
  count              = var.enabled ? 1 : 0
  name               = var.scaleup_policy_name
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    cooldown                = var.scale_up_cooldown
    metric_aggregation_type = var.metric_aggregation_type
    adjustment_type         = var.adjustment_type


    dynamic "step_adjustment" {
    for_each = var.step_scale_up_adjustments
    content {
      scaling_adjustment = lookup(step_adjustment.value ,"scaling_adjustment", null)
      metric_interval_lower_bound = lookup(step_adjustment.value, "lower_bound",null)
      metric_interval_upper_bound = lookup(step_adjustment.value, "upper_bound",null)
    }
  }

  }
}

resource "aws_appautoscaling_policy" "down" {
  count              = var.enabled ? 1 : 0
  name               = var.scaledown_policy_name
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    cooldown                = var.scale_down_cooldown
    metric_aggregation_type = var.metric_aggregation_type
    adjustment_type         = var.adjustment_type


    dynamic "step_adjustment" {
    for_each = var.step_scale_down_adjustments
    content {
      scaling_adjustment = lookup(step_adjustment.value ,"scaling_adjustment", null)
      metric_interval_lower_bound = lookup(step_adjustment.value, "lower_bound",null)
      metric_interval_upper_bound = lookup(step_adjustment.value, "upper_bound",null)
    }
  }

  }
}
