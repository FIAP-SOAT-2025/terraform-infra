resource "aws_subnet" "subnet_public" {
  count                   = 3
  vpc_id                  = aws_vpc.vpc_TC3_G38.id
  cidr_block              = cidrsubnet(aws_vpc.vpc_TC3_G38.cidr_block, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone = element(local.availability_zones, count.index % length(local.availability_zones))
  tags              = var.tags
}