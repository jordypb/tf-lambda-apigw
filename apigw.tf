resource "aws_api_gateway_rest_api" "api" {
  depends_on = [module.lambda.aws_lambda_function]
  name        = var.name
  description = "api gateway created from template swagger"

  body        = data.template_file.swagger.rendered
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

data "template_file" "swagger" {
  template = file("${path.module}/${var.swagger}")
}

resource "aws_lambda_permission" "lambda_permission" {
  depends_on = [aws_api_gateway_rest_api.api]
  action        = "lambda:InvokeFunction"
  function_name = local.lambda_name
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

