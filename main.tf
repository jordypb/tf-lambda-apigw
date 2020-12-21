// module lambda I
module "lambda_python" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "1.31.0"
  function_name      = "${local.lambda_name}-python"
  description        = "deploy of python scripts"
  handler            = "lambda_function.stocks_handler"
  runtime            = var.runtime
  source_path        = "./src-python/"
  layers = [
    aws_lambda_layer_version.lambda_layer_python.id
  ]
  environment_variables = {
    API_TOKEN = ""
    GRAPHQL_ENDPOINT = "https://qa.xyz"
  }
  memory_size        = var.memory_size
  timeout     = var.timeout
  store_on_s3 = true
  s3_bucket = var.bucket_name
  tags = {
    Environment = var.environment
  }
}
resource "aws_lambda_layer_version" "lambda_layer_python" {
  filename = "./src-python/package.zip"
#  layer_name = "layer-${module.lambda_python.this_lambda_function_name}"
#  layer_name    = module.lambda_python.this_lambda_function_name
  layer_name = "layer-${local.lambda_name}-python"
  compatible_runtimes = [var.runtime]
}

// module lambda II
module "lambda_nodejs" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "1.31.0"
  function_name      = "${local.lambda_name}-nodejs"
  description        = "deploy of nodejs scripts"
  handler            = "index.handler"
  runtime            = "nodejs12.x"
  source_path        = "./src-nodejs/"
  layers = [
    aws_lambda_layer_version.lambda_layer_nodejs.id
  ]
  environment_variables = {
    API_TOKEN 		= ""
    GRAPHQL_ENDPOINT 	= "https://qa.xyz"
  }
  memory_size   = var.memory_size
  timeout     	= var.timeout
  store_on_s3 	= true
  s3_bucket 	= var.bucket_name
  tags = {
    Environment = var.environment
  }
}
resource "aws_lambda_layer_version" "lambda_layer_nodejs" {
  filename = "./src-nodejs/package.zip"
#  layer_name = "layer-${module.lambda_nodejs.this_lambda_function_name}"
  layer_name = "layer-${local.lambda_name}-nodejs"
  compatible_runtimes = ["nodejs12.x"]
}
