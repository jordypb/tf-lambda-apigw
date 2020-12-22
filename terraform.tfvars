// ------------------terraform.tfvars to deploy lambda in aws
name        = ""
bucket_name = ""
regionaws   = "us-east-1"
profileaws  = ""
runtime     = "python3.8"
timeout     = 10
memory_size = 128
environment = "qa"
handler	    = "index.lambda_handler"
