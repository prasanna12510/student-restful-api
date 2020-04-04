variable "environment" {
}
variable "tg_arn" {
}
variable "alb_arn" {
}
variable "name" {}
variable "service" {}

variable "https_tcp_listeners_count" {}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
}

variable "https_tcp_listeners" {
  description = "A list of maps describing the HTTPS listeners for this ALB. Required key/values: port, certificate_arn. Optional key/values: ssl_policy (defaults to ELBSecurityPolicy-2016-08), target_group_index (defaults to 0)"
  type = list
  default     = []
}


variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTP listeners for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to 0)"
  type = list
  default     = []
}
variable "ssl_policy" {}

variable "certificate_arn" {}
