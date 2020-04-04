  variable "vpc_id" {}

variable "name" {}

variable "all_ips" {}

variable "any_port" {}

variable "any_protocol" {}

variable "tcp_protocol" {}

variable "tags" {
  description = "Common service and env tags"
  type        = map(string)
  default     = {}
}
