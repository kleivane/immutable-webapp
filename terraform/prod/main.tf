provider "aws" {
  region = "eu-north-1"
  version = "~> 2.47"
}

resource "aws_s3_bucket" "prod" {
  bucket = "tf-immutable-webapp-prod"
  acl    = "public-read"

  tags = {
    Name        = "immutable-webapp-prod"
    Environment = "prod"
  }
}

module "immutable_cloudfront" {
  source = "git@github.com:kleivane/terraform-aws-cloudfront-s3-assets.git?ref=0.1.0"

  bucket_origin_id = "S3-${aws_s3_bucket.prod.id}"
  bucket_domain_name = aws_s3_bucket.prod.bucket_regional_domain_name
  environment= "prod"
}

output "bucket_id_asset" {
  value = module.immutable_cloudfront.bucket_id
}

output "bucket_prod" {
  value = aws_s3_bucket.prod.id
}

output "domain_name_prod" {
  value = module.immutable_cloudfront.distribution.domain_name
}
