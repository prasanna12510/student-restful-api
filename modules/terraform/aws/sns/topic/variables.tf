
variable "name" {}

variable "display_name" {
  type = string
  default = ""
}

variable "tags" {
  description = "Common service and env tags"
  type        = map(string)
  default     = {}
}


variable "create_topic"{}
