variable "aliases" {
  type    = list(string)
  default = []
}

variable "recordtype" {
  default = "CNAME"
}

variable "target_dns_name" {
  default = ""
}
variable "target_zone_id" {
  default = ""
}

variable "ttl" {
  type    = number
  default = 300
}

variable "dns_name_list" {
  type = list(string)
  default = []
}

variable "is_A_record" {
  type = bool
  default = false
}

variable "dns_value_list" {
  type = list(string)
  default = []
}

variable "zone_id" {}

variable "evaluate_target_health" {
  type        = bool
  default     = true
  description = "evaluate target health for A record"
}
