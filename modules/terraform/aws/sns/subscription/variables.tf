variable "create_subscription"{
  type = bool
  default = false
}

variable "topic_arn" {
  type = string
}

variable "protocol" {
  type = string
}

variable "endpoint" {
  type = string
}
