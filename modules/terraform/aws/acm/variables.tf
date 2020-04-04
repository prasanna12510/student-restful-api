variable "domainname" {
  description = "acm domain name"
  type  = list
  default = []
}

variable "tags" {
  description = "Additional tags for the acm"
  type        = map(string)
  default     = {}
}


variable "zone_id" {
    description = "The ID of the hosted zone to contain this record."
    type        = string
    default     = ""
}


variable "subject_alternative_names" {
  description = "A list of domains that should be SANs in the issued certificate"
  type        = list(string)
  default     = []
}

variable "wait_for_validation" {
description = "Whether to wait for the validation to complete"
type        = bool
default     = true
}


variable "create_certificate" {
  description = "Whether to create ACM certificate"
  type        = bool
  default     = true
}

variable "validate_certificate" {
  description = "Whether to validate certificate by creating Route53 record"
  type        = bool
  default     = true
}

variable "validation_allow_overwrite_records" {
  description = "Whether to allow overwrite of Route53 records"
  type        = bool
  default     = true
}

variable "validation_method" {
  description = "Which method to use for validation. DNS or EMAIL are valid, NONE can be used for certificates that were imported into ACM and then into Terraform."
  type        = string
  default     = "DNS"
}
