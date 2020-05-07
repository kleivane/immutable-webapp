locals {
  env = "test"
}

provider "aws" {
  region  = "eu-north-1"
  version = "~> 2.47"
}

# Opprett bucket for assets felles for alle miljøer
# https://www.terraform.io/docs/providers/aws/r/s3_bucket.html

resource "aws_s3_bucket" "assets" {
  bucket = "tf-2-assets"

  tags = {
    system      = "immutable-webapp"
    environment = "common"
    managed_by  = "terraform"
  }
}

# Opprett bucket for testmiljø som skal serve index.html


resource "aws_s3_bucket" "host" {
  bucket = "tf-2-host-${local.env}"

  tags = {
    system      = "immutable-webapp"
    environment = local.env
    managed_by  = "terraform"
  }
}

resource "aws_s3_bucket_policy" "public_host" {
  bucket = aws_s3_bucket.host.id

  policy = templatefile("policy/public_bucket.json.tpl", { bucket_arn = aws_s3_bucket.host.arn })
}

resource "aws_s3_bucket_policy" "public_asset" {
  bucket = aws_s3_bucket.assets.id

  policy = templatefile("policy/public_bucket.json.tpl", { bucket_arn = aws_s3_bucket.assets.arn })
}


output "host_id" {
  value = aws_s3_bucket.host.id
}

output "domain_name" {
  value = aws_s3_bucket.host.bucket_domain_name
}
