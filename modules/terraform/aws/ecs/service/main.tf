### ECS Service
resource "aws_ecs_service" "main" {
  name                               = var.service_name
  task_definition                    = var.task_definition
  desired_count                      = var.desired_count
  cluster                            = var.cluster_name
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  iam_role                           = var.scheduling_strategy == "REPLICA" ? var.ecs_service_role : null
  launch_type                        = length(var.capacity_provider_strategies) > 0 ? null : var.launch_type
  platform_version                   = var.launch_type == "FARGATE" ? var.platform_version : null
  scheduling_strategy                = var.launch_type == "FARGATE" ? "REPLICA" : var.scheduling_strategy

  #capacity provider for cluster autoscaling
  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategies
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = lookup(capacity_provider_strategy.value, "base", null)
    }
  }

  #placement strategy for service : binpack, instance_id-spread, AZ-balanced-spread etc
  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy
    content {
      type  = ordered_placement_strategy.value.type
      field = lookup(ordered_placement_strategy.value, "field", null)
    }
  }

  # placement constraint like placing task in specific AZ, subnets or instancetype
  dynamic "placement_constraints" {
    for_each = var.service_placement_constraints
    content {
      type       = placement_constraints.value.type
      expression = lookup(placement_constraints.value, "expression", null)
    }
  }

  # adding loadbalancer with targetgroup to the service
  dynamic "load_balancer" {
    for_each = var.ecs_load_balancers
    content {
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
      target_group_arn = lookup(load_balancer.value, "target_group_arn", null)
    }
  }

  # Allow external changes without Terraform plan difference
  lifecycle {
    ignore_changes = [desired_count]
  }
}
