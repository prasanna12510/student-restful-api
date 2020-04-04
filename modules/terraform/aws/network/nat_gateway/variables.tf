variable "name" {}

variable "azs" {}

variable "tags" {
  description = "Common service and env tags"
  type        = map(string)
  default     = {}
}
variable "nat_gateway_tags" {
  description = "Additional tags for the nat gateway tags"
  type        = map(string)
  default     = {}
}

variable "public_subnet_ids" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
}
