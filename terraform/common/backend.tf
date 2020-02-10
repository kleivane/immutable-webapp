resource "aws_s3_bucket" "tf-state-storage-s3" {
    bucket = "tf-immutable-infrastructure-remote-state-storage"

    versioning {
      enabled = true
    }

    lifecycle {
      prevent_destroy = true
    }

    tags = {
      Name = "S3 Remote Terraform State Store"
    }
}

resource "aws_s3_bucket_public_access_block" "tf-state-storage-s3" {
  bucket = aws_s3_bucket.tf-state-storage-s3.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true

}

terraform {
  backend "s3" {
    bucket = "tf-immutable-infrastructure-remote-state-storage"
    key    = "immutable_web_app_common"
    region = "eu-north-1"
  }
}
