variable "vpc" {}

variable "launch_config_name" {}

variable "min_size" {}

variable "max_size" {}

#tags
variable "name" {}

variable "owner" {}

variable "environment" {}

variable "target_group_arn" {}

variable "desired_capacity" {}

variable "health_check_type" {}

variable "termination_policy" {}

variable "health_check_grace_period" {}

variable "default_cooldown" {}

variable "default_as_termination_policy" {
  default = "Default"
}