variable "name" {
  description = "The name of the log group."
  type        = string
  default     = ""
}

variable "log_groups" {
  description = "A list of maps containing key/value pairs that loggroup names."
  type = map
  default = {}
}

variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group."
  default     = 180
}

variable "tags" {
  description = "Put tags for each cloudwatch log group in map(string) format"
  type        = map(string)
  default     = {}
}

variable "kms_arn" {
  description = "Put kms ARN to encrypt log group"
  default     = ""
}
