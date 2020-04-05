#route53 variables
variable "hosted_zone_name" {
  default = "play-hooq.tv"
}

variable "certificate_domain_name" {
  default = "*.play-hooq.tv"
}
