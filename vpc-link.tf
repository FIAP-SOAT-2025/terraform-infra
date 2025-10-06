resource "aws_apigatewayv2_vpc_link" "vpc_link" {
  name               = "vpc-link-lanchonete-v1"
  subnet_ids         = aws_subnet.subnet_private[*].id
  security_group_ids = [aws_security_group.sg.id]
}

output "vpc_link_id" {
  description = "ID of the VPC Link"
  value       = aws_apigatewayv2_vpc_link.vpc_link.id
}
