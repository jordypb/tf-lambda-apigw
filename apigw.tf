# https://ordina-jworks.github.io/cloud/2019/01/14/Infrastructure-as-code-with-terraform-and-aws-serverless.html#api-gateway
resource "aws_api_gateway_rest_api" "api" {
  depends_on = ["module.lambda_python.aws_lambda_function","module.lambda_nodejs.aws_lambda_function"]
  name        = var.name
  description = "api gateway created from template swagger"
  body        = data.template_file.codingtips_api_swagger.rendered
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}
data "template_file" codingtips_api_swagger{
  template = file("swagger.yaml")
  vars = {
    name_apigw = var.name
    arn_invoke_lambda_python = module.lambda_python.this_lambda_function_invoke_arn
    arn_invoke_lambda_nodejs = module.lambda_nodejs.this_lambda_function_invoke_arn
  }
}

resource "aws_lambda_permission" "lambda_permission_python" {
  depends_on = [aws_api_gateway_rest_api.api]
  action        = "lambda:InvokeFunction"
#  function_name = local.lambda_name
  function_name = module.lambda_python.this_lambda_function_name
  principal     = "apigateway.amazonaws.com"
  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}
resource "aws_lambda_permission" "lambda_permission_nodejs" {
  depends_on = [aws_api_gateway_rest_api.api]
  action        = "lambda:InvokeFunction"
#  function_name = module.lambda_python.function_name
  function_name = module.lambda_nodejs.this_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*/*"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.environment
  variables = {
    "answer" = "42"
  }
  lifecycle {
    create_before_destroy = true
  }
}
