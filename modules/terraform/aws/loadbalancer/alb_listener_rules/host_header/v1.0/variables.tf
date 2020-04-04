variable "environment" {
}
variable "tg_arn" {
}
variable "name" {}

variable "is_hostheader" {
  type = bool
  default = false
}

variable "host_header_listener_count" {}
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

variable "host_header_listener_rules" {}

