
variable "tg_arn" {
}

variable "path_pattern_listener_count" {}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "http_listener_arn" {}

variable "path_pattern_listener_rules" {}
