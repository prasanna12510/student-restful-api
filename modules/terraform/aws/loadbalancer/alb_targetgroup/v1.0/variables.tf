variable "name" {}

variable "create_albtg" {
  description = "Controls if the ALB should be created"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port. Optional key/values are in the target_groups_defaults variable."
  type        = list(map(string))
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
}

variable "target_groups_defaults" {
  description = "Default values for target groups as defined by the list of maps."
  type = object(
  {
    cookie_duration                  = string,
    deregistration_delay             = string,
    health_check_interval            = string,
    health_check_healthy_threshold   = string,
    health_check_path                = string,
    health_check_port                = string,
    health_check_timeout             = string,
    health_check_unhealthy_threshold = string,
    health_check_matcher             = string,
    stickiness_enabled               = string,
    target_type                      = string,
    slow_start                       = string,
  }
  )
  default = {
    cookie_duration                  = 86400
    deregistration_delay             = 300
    health_check_interval            = 10
    health_check_healthy_threshold   = 3
    health_check_path                = "/"
    health_check_port                = "traffic-port"
    health_check_timeout             = 5
    health_check_unhealthy_threshold = 3
    health_check_matcher             = "200-299,301,302"
    stickiness_enabled               = true
    target_type                      = "ip"
    slow_start                       = 0
  }
}