resource "aws_vpc" "vpc_TC3_G38" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.tags
}

