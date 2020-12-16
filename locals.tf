locals {
  lambda_name=var.name
  region=var.regionaws
  common_tags = {
    Owner       = "yavinenana"
    Environment = var.environment
    platform    = "python"
    "kubernetes.io/cluster/saleor-backend" = "owned"
  }
}
