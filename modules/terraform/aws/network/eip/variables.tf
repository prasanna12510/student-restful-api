variable "name" {}

variable "nat_gateway_count" {}

variable "tags" {
  description = "Common service and env tags"
  type        = map(string)
  default     = {}
}
