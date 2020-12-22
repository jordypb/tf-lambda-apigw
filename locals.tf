locals {
  lambda_name_layer=module.lambda.this_lambda_function_name
  lambda_name=var.name
  region=var.regionaws
  common_tags = {
    Owner       = "yavinenana"
    Environment = var.environment
    platform    = "python"
    "kubernetes.io/cluster/saleor-backend" = "owned"
  }
}
