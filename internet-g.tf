resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_TC3_G38.id
}