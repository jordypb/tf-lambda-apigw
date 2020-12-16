resource "aws_api_gateway_rest_api" "api" {
  name        = var.name
  description = "This is my API for demonstration purposes"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
resource "aws_lambda_permission" "lambda_permission" {
#  statement_id  = "AllowMyDemoAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}
resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
  request_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration" "integration" {
  depends_on = [module.lambda.this_lambda_function_invoke_arn]
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
#  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:729405875301:function:lambda-test/invocations"
  uri                     = module.lambda.this_lambda_function_invoke_arn

  passthrough_behavior    = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
#  response_parameters = { 
#    "method.response.header.X-Some-Header" = true 
#  }
}

resource "aws_api_gateway_integration_response" "MyDemoIntegrationResponse" {
#  depends_on = [module.lambda.this_lambda_function_invoke_arn,aws_api_gateway_integration.integration]
  depends_on = [aws_api_gateway_integration.integration]
#  depends_on = [aws_api_gateway_integration.integration.uri]
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
# Transforms the incoming XML request to JSON
  response_templates = {
    "application/json" = ""
  }
}

#resource "aws_api_gateway_stage" "test" {
#  stage_name    = "test"
#  rest_api_id   = aws_api_gateway_rest_api.api.id
#  deployment_id = aws_api_gateway_deployment.deployment.id
#  depends_on = [aws_cloudwatch_log_group.example]
#}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.integration]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.environment

  variables = {
    "answer" = "42"
  }

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_cloudwatch_log_group" "example" {
  name              = "API-Gateway-Execution-Logs_${aws_api_gateway_rest_api.api.name}/${var.environment}"
  retention_in_days = 7
  # ... potentially other configuration ...
}
