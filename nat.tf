resource "aws_eip" "nat_gateway_eip" {
  count  = 3
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      "Name" = "nat-gateway-eip-${count.index}"
    }
  )
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = 3
  allocation_id = aws_eip.nat_gateway_eip[count.index].id
  subnet_id     = aws_subnet.subnet_public[count.index].id

  tags = merge(
    var.tags,
    {
      "Name" = "nat-gateway-${count.index}"
    }
  )
}
