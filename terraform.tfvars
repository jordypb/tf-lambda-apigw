// ------------------terraform.tfvars to deploy lambda in aws
name        = "sap_integrations"
bucket_name = "deploybucketlambdas"
regionaws   = "us-east-2"
profileaws  = "QA-AUNA"
runtime     = "python3.8"
timeout     = 10
memory_size = 128
environment = "qa"
