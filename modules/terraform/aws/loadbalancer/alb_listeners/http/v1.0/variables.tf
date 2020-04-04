variable "alb_arn" {
  description = "ARN of the load balancer to which the listener will be attached to"
  type        = list(string)
}

variable "http_tcp_listeners" {
  description = "A list of maps describing the HTTP listeners for this ALB. Required key/values: port, protocol. Optional key/values: target_group_index (defaults to 0)"
  type        = list
  default     = []
}

variable "default_action" {
  description = "Default action if there are no other mathing rules. Valid values are 'redirect-to-https' or 'forward'. Default to 'redirect-to-https'."
  type        = string
  default     = "redirect-to-https"
}

variable "default_tg_arn" {
  default = ""
}
