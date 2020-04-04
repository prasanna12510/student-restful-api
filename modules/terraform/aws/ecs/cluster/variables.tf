variable "vpc_id" {}

variable "name" {}

variable "tags" {
  description = "Common service and env tags"
  type        = map(string)
  default     = {}
}
