data "aws_lb" "internal_lb" {
  depends_on = [kubectl_manifest.service]
  tags = {
    "service.kubernetes.io/service-name" = "lanchonete-tc2/api-service"
  }
}

resource "aws_api_gateway_rest_api" "api_gateway" {
  name        = "lanchonete-api-gateway"
  description = "API Gateway lanchonete"
}

resource "aws_api_gateway_vpc_link" "vpc_link" {
  name        = "lanchonete-vpc-link"
  target_arns = [data.aws_lb.internal_lb.arn]
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "proxy_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method

  type                    = "http_proxy"
  integration_http_method = "ANY"
  uri                     = "http://${data.aws_lb.internal_lb.dns_name}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.vpc_link.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.proxy_integration]

  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "v1"
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.deployment.invoke_url
}
