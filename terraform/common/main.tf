provider "aws" {
  region = "eu-north-1"
  version = "~> 2.47"
}
resource "aws_s3_bucket" "assets" {
  bucket = "tf-immutable-webapp-assets"
  acl    = "public-read"

  tags = {
    Name = "assets"
  }
}

output "id" {
  value = aws_s3_bucket.assets.id
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.assets.bucket_regional_domain_name
}
