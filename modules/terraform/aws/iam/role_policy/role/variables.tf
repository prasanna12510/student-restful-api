variable "role_name" {}

variable "create_instance_role" {
  description = "Need to create a same name instance role or not"
  default     = false
}

variable "iam_assume_role_policy_data" {
  type = string
}
