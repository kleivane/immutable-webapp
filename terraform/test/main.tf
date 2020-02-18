terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "eu-north-1"
  version = "~> 2.47"
}

locals {
  url         = "test.skysett.net"
  environment = "test"
}


resource "aws_s3_bucket" "test" {
  bucket = "tf-immutable-webapp-test"
  acl    = "public-read"

  tags = {
    Name        = local.environment
    Environment = local.environment
  }
}


module "immutable_cloudfront" {
  source = "git@github.com:kleivane/terraform-aws-cloudfront-s3-assets.git?ref=0.3.0"

  bucket_origin_id = "S3-${aws_s3_bucket.test.id}"
  bucket_domain_name = aws_s3_bucket.test.bucket_regional_domain_name
  environment= local.environment

  aliases = [local.url]
}

data "aws_route53_zone" "primary" {
  name         = "skysett.net."
}

resource "aws_route53_record" "ipv4" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${local.url}."
  type    = "A"

  alias {
    name                   = module.immutable_cloudfront.distribution.domain_name
    zone_id                = module.immutable_cloudfront.distribution.hosted_zone_id
    evaluate_target_health = false

  }
}

resource "aws_route53_record" "ipv6" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${local.url}."
  type    = "AAAA"

  alias {
    name                   = module.immutable_cloudfront.distribution.domain_name
    zone_id                = module.immutable_cloudfront.distribution.hosted_zone_id
    evaluate_target_health = false

  }
}

module "deployer" {
  source = "../common/modules/terraform-aws-lambda-s3-deployer"

  src_version = "0.0.6"
  api_url = module.immutable_cloudfront.distribution.domain_name
  bucket = {
    id = aws_s3_bucket.test.id
    arn = aws_s3_bucket.test.arn
  }

  environment= local.environment
}
