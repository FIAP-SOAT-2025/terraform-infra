resource "aws_subnet" "subnet_public" {
  count                   = 3
  vpc_id                  = aws_vpc.vpc_TC3_G38.id
  cidr_block              = cidrsubnet(aws_vpc.vpc_TC3_G38.cidr_block, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, count.index % length(data.aws_availability_zones.available.names))
  tags              = var.tags
}