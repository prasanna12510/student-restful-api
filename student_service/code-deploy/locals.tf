
locals {
  name                     = var.env[terraform.workspace].name
  service_name             = local.name
  task_definition_name     = local.name

  tags = {
    service_name = local.service_name
    owner        = var.owner
    environment  = terraform.workspace
    version      = var.tag
  }

  //cloudwatch monitoring and alarm
  ecs_dimensions_map = {
    ClusterName = data.terraform_remote_state.student-service_infra_state.outputs.ecs_cluster_name
    ServiceName = module.student-api-ecs-service.ecs_service
  }
}

##local variables for container_definition
locals {
  container_port  = 8080
  container_image = "prasanna1994/student-api:${var.tag}"
  aws_account_id  = data.aws_caller_identity.current.account_id
  container_secrets = [
    {
      name      = "NAME"
      valueFrom = "arn:aws:ssm:${var.region}:${local.aws_account_id}:parameter/app/student-service/NAME"
    },
    {
      name      = "PORT"
      valueFrom = "arn:aws:ssm:${var.region}:${local.aws_account_id}:parameter/app/student-service/PORT"
    },
    {
      name      = "VPCID"
      valueFrom = "arn:aws:ssm:${var.region}:${local.aws_account_id}:parameter/app/student-service/VPCID"
    }
  ]

  log_configuration = {
    logDriver = "awslogs"
    options = {
      awslogs-group         = "${local.service_name}-${terraform.workspace}-logs"
      awslogs-region        = var.region
      awslogs-stream-prefix = var.container_name
    }
  }

}

//ecs service autoscaling
locals {
  max_capacity         = var.env[terraform.workspace].max_capacity
  min_capacity         = var.env[terraform.workspace].min_capacity
  //ECS Task autoscaling policy step scaling --> ScaleUP
  scale_up_adjustments = var.env[terraform.workspace].scaling_up_adjustments
  //ECS Task autoscaling policy step scaling --> ScaleDown
  scale_down_adjustments = var.env[terraform.workspace].scaling_down_adjustments
  // Deployment Health
  deployment_minimum_healthy_percent = var.env[terraform.workspace].deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.env[terraform.workspace].deployment_maximum_percent

  //load_balancer with targetgroup attached to service
  ecs_load_balancers = [{
    container_name   = var.container_name
    container_port   = local.container_port
    target_group_arn = data.terraform_remote_state.student-service_infra_state.outputs.alb_targetgroups_arns

  }]

}
