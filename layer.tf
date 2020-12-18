resource "aws_lambda_layer_version" "lambda_layer" {
  filename = "package.zip"
# can be local  package or by s3
  layer_name = "layer-${local.lambda_name}"

  compatible_runtimes = [var.runtime]
}
