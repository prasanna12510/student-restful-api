variable "role_arn" {
  type = string
  description = "ecs service role arn"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Enable/disable resources creation"
}

variable "min_capacity" {
  type        = number
  description = "Minimum number of running instances of a Service"
  default     = 1
}

variable "max_capacity" {
  type        = number
  description = "Maximum number of running instances of a Service"
  default     = 2
}

variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster where service is to be autoscaled"
}

variable "service_name" {
  type        = string
  description = "The name of the ECS Service to autoscale"
}

variable "scaleup_policy_name" {
  type        = string
  description = "ecs scaling up policy name"
}

variable "step_scale_up_adjustments" {
  description = "Scaling adjustment to make during scale up event"
}

variable "scale_up_cooldown" {
  type        = number
  description = "Period (in seconds) to wait between scale up events"
  default     = 60
}

variable "scaledown_policy_name" {
  type        = string
  description = "ecs scaling down policy name"
}

variable "step_scale_down_adjustments" {
  description = "Scaling adjustment to make during scale down event"
}

variable "scale_down_cooldown" {
  type        = number
  description = "Period (in seconds) to wait between scale down events"
  default     = 60
}

variable "adjustment_type" {
  type      = string
  default   = "ChangeInCapacity"
}


variable "metric_aggregation_type" {
  type    = string
  default = "Average"
}
