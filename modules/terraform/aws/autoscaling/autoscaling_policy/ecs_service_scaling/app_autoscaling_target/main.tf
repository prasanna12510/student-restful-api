resource "aws_appautoscaling_target" "target" {
  service_namespace  = var.service_namespace
  role_arn           = var.role_arn
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  scalable_dimension = var.scalable_dimension
  resource_id        = "service/${var.ecs_cluster_name}/${var.ecs_service_name}"
  depends_on         = [var.ecs_service_name]
}
