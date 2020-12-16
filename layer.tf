# https://registry.terraform.io/modules/corpit-consulting-public/lambda-layer-version-mod/aws/latest
# https://forums.aws.amazon.com/thread.jspa?threadID=247365
resource "aws_lambda_layer_version" "lambda_layer" {
  filename = "package.zip"
# puede ser local o s3
  layer_name = "layer-${local.lambda_name}"

  compatible_runtimes = [var.runtime]
}
