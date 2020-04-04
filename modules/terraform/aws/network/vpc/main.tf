################### VPC ###################

resource "aws_vpc_dhcp_options" "dhcp" {
  domain_name         = "ap-southeast-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = merge(

    { "Name" = format("%s", var.name) },

    var.tags,

  )
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  instance_tenancy     = var.instance_tenancy
  tags = merge(

    { "Name" = format("%s", var.name) },

    var.tags,

  )
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.dhcp.id
}

resource "aws_internet_gateway" "internet_gateway" {
  count  = var.create_igw ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(

    { "Name" = format("%s", var.name) },

    var.tags,

  )
}
