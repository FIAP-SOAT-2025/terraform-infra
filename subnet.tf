resource "aws_subnet" "subnet_private" {
  count                   = 3
  vpc_id                  = aws_vpc.vpc_TC3_G38.id
  cidr_block              = cidrsubnet(aws_vpc.vpc_TC3_G38.cidr_block, 8, count.index + 3)
  map_public_ip_on_launch = false
  availability_zone       = element(local.availability_zones, count.index % length(local.availability_zones))

  tags = merge(
    var.tags,
    {
      "Name" = "subnet-private-${count.index}"
    }
  )
}

resource "aws_subnet" "subnet_public" {
  count                   = 3
  vpc_id                  = aws_vpc.vpc_TC3_G38.id
  cidr_block              = cidrsubnet(aws_vpc.vpc_TC3_G38.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(local.availability_zones, count.index % length(local.availability_zones))

  tags = merge(
    var.tags,
    {
      "Name" = "subnet-public-${count.index}"
    }
  )
}