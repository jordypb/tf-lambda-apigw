module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "1.31.0"
  # insert the 27 required variables here

  function_name      = local.lambda_name
  description        = "deploy of python scripts"
#  handler            = "index.lambda_handler"
  handler            = "lambda_function.stocks_handler"
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime            = var.runtime
  source_path        = "./src/"
#  create_package         = false
#  local_existing_package = "./package.zip"
  layers = [
    aws_lambda_layer_version.lambda_layer.id
  ]
#  environment_variables = {
#    API_TOKEN = ""
#    GRAPHQL_ENDPOINT = "https://qa.xyz"
#  }
  memory_size        = var.memory_size
  timeout     = var.timeout
  store_on_s3 = true
  s3_bucket = var.bucket_name


  tags = {
    Environment = var.environment
  }
}
