provider "aws" {
  region = "eu-north-1"
  version = "~> 2.47"
}

locals {
  environment = "prod"
}

resource "aws_s3_bucket" "prod" {
  bucket = "tf-immutable-webapp-prod"
  acl    = "public-read"

  tags = {
    Name        = "immutable-webapp-prod"
    Environment = local.environment
  }
}

module "immutable_cloudfront" {
  source = "git@github.com:kleivane/terraform-aws-cloudfront-s3-assets.git?ref=0.1.0"

  bucket_origin_id = "S3-${aws_s3_bucket.prod.id}"
  bucket_domain_name = aws_s3_bucket.prod.bucket_regional_domain_name
  environment= local.environment
}

module "deployer" {
  source = "../common/modules/terraform-aws-lambda-s3-deployer"

  src_version = "0.0.6"
  api_url = module.immutable_cloudfront.distribution.domain_name
  bucket = {
    id = aws_s3_bucket.prod.id
    arn = aws_s3_bucket.prod.arn
  }

  environment= local.environment
}
