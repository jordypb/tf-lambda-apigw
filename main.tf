module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "1.31.0"
  # insert the 27 required variables here

  function_name      = local.lambda_name
  description        = "description should be here"
  handler            = var.handler
# https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
  runtime            = var.runtime
  source_path        = "./src/"
#  source_path        = "git@github.com:jordypb/lambda_python.git"
#  create_package         = false
#  local_existing_package = "./package.zip"
  layers = [
    aws_lambda_layer_version.lambda_layer.id
#    "arn:aws:lambda:us-east-1:729405875301:layer:testlayer:1"
  ]
  environment_variables = {
    token = "12345"
    endpoint = "https://www.endpoint.com/resource/"
  }
  memory_size        = var.memory_size
  timeout     = var.timeout
  store_on_s3 = true
  s3_bucket = var.bucket_name
#  role_arn           = "arn:aws:iam::aws:policy/AmazonSESFullAccess"

  tags = {
    Environment = var.environment
  }
}
# https://registry.terraform.io/modules/corpit-consulting-public/lambda-layer-version-mod/aws/latest
# https://forums.aws.amazon.com/thread.jspa?threadID=247365
resource "aws_lambda_layer_version" "lambda_layer" {
  filename = "package.zip"
# puede ser local o s3
  layer_name = "layer-${local.lambda_name}"
  compatible_runtimes = [var.runtime]
}
