variable "environment" {
}
variable "tg_arn" {
}
variable "name" {}
variable "service" {}

variable "path_pattern_listener_count" {}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
}
variable "http_listener_arn" {}

variable "path_pattern_listener_rules" {}