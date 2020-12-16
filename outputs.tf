output "invoke_url" {
  value = aws_api_gateway_deployment.deployment
#  value = aws_api_gateway_deployment.deployment.execution_arn
#  value = aws_api_gateway_deployment.deployment.invoke_url
}

output "path_resource" {
  value = aws_api_gateway_resource.resource.path
}
