
variable "availability_zones" {
  default = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "env" {
  default = {
      play = {
      name                               = "student-api-play"
      desired_task_count                 = 2
      max_capacity                       = 10
      min_capacity                       = 2
      deployment_minimum_healthy_percent = 50
      deployment_maximum_percent         = 200
      #ScaleDown
      scaling_down_adjustments = [

        {
          scaling_adjustment = -1
          lower_bound        = -5
          upper_bound        = 0
        },
        {
          scaling_adjustment = -2
          lower_bound        = -10
          upper_bound        = -5
        },
        {
          scaling_adjustment = -3
          upper_bound        = -10
        }

      ]
      #Scaleup
      scaling_up_adjustments = [

        {
          scaling_adjustment = 1
          lower_bound        = 0
          upper_bound        = 15
        },
        {
          scaling_adjustment = 2
          lower_bound        = 15
          upper_bound        = 25
        },
        {
          scaling_adjustment = 3
          lower_bound        = 25
        }
      ]
    }
  }
}


#####container_definition variables####

variable "container_memory_reservation" {
  type        = number
  description = "The amount of memory (in MiB) to reserve for the container. If container needs to exceed this threshold, it can do so up to the set container_memory hard limit"
  default     = 1024
}

variable "port_mappings" {
  description = "The port mappings to configure for the container. This is a list of maps. Each map should contain \"containerPort\", \"hostPort\", and \"protocol\", where \"protocol\" is one of \"tcp\" or \"udp\". If using containers in a task with the awsvpc or host network mode, the hostPort can either be left blank or set to the same value as the containerPort"
  default = [{
    containerPort = 8080
    hostPort      = 0
    protocol      = "tcp"
  }]
}

variable "container_cpu" {
  type        = number
  description = "The number of cpu units to reserve for the container. This is optional for tasks using Fargate launch type and the total amount of container_cpu of all containers in a task will need to be lower than the task-level cpu value"
  default     = 512
}

variable "ulimits" {
  description = "Container ulimit settings. This is a list of maps, where each map should contain \"name\", \"hardLimit\" and \"softLimit\""
  default = [{
    name      = "nofile"
    hardLimit = 30000
    softLimit = 10000
  }]
}

#########################

variable "desired_count" {
  type    = number
  default = 2
}

variable "scheduling_strategy" {
  type    = string
  default = "REPLICA"
}

variable "min_capacity" {
  default = "1"
}

variable "max_capacity" {
  default = "3"
}

variable "container_name" {
  description = "Tag: Service Name for all resources"
  default     = "student-api"
}
variable "owner" {
  description = "Tag: Owner of the resources"
  default     = "student-api"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "tag" {
  default = "APP_TAG"
}

variable "autoscaling_policy_scaleup_cooldown" {
  default = "60"
}

variable "autoscaling_policy_scaledown_cooldown" {
  default = "60"
}

variable "autoscaling_policy_adjustment_type" {
  default = "ChangeInCapacity"
}

variable "autoscaling_policy_metric_aggregation_type" {
  default = "Maximum"
}
