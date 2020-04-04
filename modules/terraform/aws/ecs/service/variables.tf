variable "service_name" {
}

variable "deployment_minimum_healthy_percent" {
  type = number
  default = 100
}
variable "deployment_maximum_percent" {
  type = number
  default = 200
}

variable "health_check_grace_period_seconds" {
  type        = number
  description = "Seconds to ignore failing load balancer health checks"
  default     = 0
}

variable "ecs_service_role" {
  default = ""
}
variable "desired_count" {
  type = number
}
variable "cluster_name" {
}

variable "capacity_provider_strategies" {
  type = list(object({
    capacity_provider = string
    weight            = number
    base              = number
  }))
  description = "The capacity provider strategies to use for the service. See `capacity_provider_strategy` configuration block: https://www.terraform.io/docs/providers/aws/r/ecs_service.html#capacity_provider_strategy"
  default     = []
}

variable "ecs_load_balancers" {
  type = list(object({
    container_name   = string
    container_port   = number
    target_group_arn = string
  }))
  description = "A list of load balancer config objects for the ECS service; see `load_balancer` docs https://www.terraform.io/docs/providers/aws/r/ecs_service.html"
  default     = []
}

variable "ordered_placement_strategy" {
  type = list(object({
    type  = string
    field = string
  }))
  description = "Service level strategy rules that are taken into consideration during task placement. List from top to bottom in order of precedence. The maximum number of ordered_placement_strategy blocks is 5. See `ordered_placement_strategy` docs https://www.terraform.io/docs/providers/aws/r/ecs_service.html#ordered_placement_strategy-1"
  default     = []
}

variable "service_placement_constraints" {
  type = list(object({
    type       = string
    expression = string
  }))
  description = "The rules that are taken into consideration during task placement. Maximum number of placement_constraints is 10. See `placement_constraints` docs https://www.terraform.io/docs/providers/aws/r/ecs_service.html#placement_constraints-1"
  default     = []
}


variable "launch_type" {
  type        = string
  description = "The launch type on which to run your service. Valid values are `EC2` and `FARGATE`"
  default     = "EC2"
}


variable "platform_version" {
  type        = string
  description = "The platform version on which to run your service. Only applicable for launch_type set to FARGATE. More information about Fargate platform versions can be found in the AWS ECS User Guide."
  default     = "LATEST"
}

variable "scheduling_strategy" {
  type        = string
  description = "The scheduling strategy to use for the service. The valid values are REPLICA and DAEMON. Note that Fargate tasks do not support the DAEMON scheduling strategy."
  default     = "REPLICA"
}

variable "task_definition" {
  type = string
}
