variable "certificate_name" {
  description = "Name of the ACM certificate."
  type        = string
}

variable "product_domain" {
  description = "Abbreviation of the product domain this ACM certificate belongs to."
  type        = string
}

variable "environment" {
  description = "Environment this ACM certificate belongs to."
  type        = string
}

variable "description" {
  description = "Free form description of this ACM certificate."
  type        = string
}

variable "domain_name" {
  description = "Domain name the certificate is issued for."
  type        = string
}

variable "hosted_zone_name" {
  description = "Need for DNS validation, hosted zone name where record validation will be stored."
  type        = string
}

variable "validation_allow_overwrite_records" {
  description = "Whether to allow overwrite of Route53 records"
  type        = bool
  default     = true
}
