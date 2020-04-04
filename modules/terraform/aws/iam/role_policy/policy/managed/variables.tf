variable "role_name" {}

variable "iam_managed_policy_arns" {
  type        = list
  description = "List of policy arns to attach to this role"
  default     = null
}
