
variable "tg_arn" {
}

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

variable "http_listener_arn" {}

variable "host_header_listener_rules" {}
