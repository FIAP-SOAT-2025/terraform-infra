resource "aws_apigatewayv2_api" "http_api" {
  name          = "http-api-lanchonete-v1"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

output "api_gateway_id" {
  description = "ID do API Gateway"
  value       = aws_apigatewayv2_api.http_api.id
}

output "api_gateway_url" {
  description = "URL do API Gateway"
  value       = aws_apigatewayv2_stage.default.invoke_url
}
