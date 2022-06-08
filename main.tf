variable "credentials_file" { default = "/home/terraform-admin/.aws/credentials"}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.48.0"
    }
  }
  backend "s3" {
    bucket = "tf-state"
    region = var.aws_region
    key    = "challenge1.tfstate"
  }

}

provider "aws" {
  region = var.aws_region
  profile = "default"
  shared_credentials_file = var.credentials_file
}

module "static-s3-web-app" {
  source = "/modules/web-app"
  cloudfront_comment    = "web app cloudfront"
  web_domain_53         = "webapp.example.com"  
  s3_bucket_name        = "s3-webapp"  
  webapp_file           = "../webapp.zip"
  tag                   = "challenge1"
}  

module "lambda-iam" {
  source = "./modules/iam"
  tag    = "challenge1"
}

module "api-lambda" {
  source = "./modules/lambda"
  lambda_runtime = "nodejs12.x"
  handler = "index.handler"
  role = module.lambda-iam.IAM_ROLE_ARN
  s3_bucket_name = "s3-lambda-bucket"
  tag    = "challenge1"
}

module "api-gateway" {
  source = "./modules/api-gateway"
  function_name = module.api-lambda.lambda_function_name
  uri = module.lambda.uri
  tag    = "challenge1"
} 

module "database" {
  source = "./modules/Dynamodb"
  name   ="appdb" 
  tag    = "challenge1"
}
