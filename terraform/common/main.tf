provider "aws" {
  region = "eu-north-1"
  version = "~> 2.47"
}
resource "aws_s3_bucket" "assets" {
  bucket = "tf-immutable-webapp-assets"

  tags = {
    Name = "assets"
  }
}

resource "aws_s3_bucket_policy" "public" {
  bucket = aws_s3_bucket.assets.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "Policy1582630604704",
  "Statement": [
    {
      "Sid": "Stmt1582630385628",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${aws_s3_bucket.assets.arn}/*"
    }
  ]
}
POLICY
}


resource "aws_s3_bucket" "deploy_assets" {
  bucket = "immutable-webapp-deploy-src"

  tags = {
    Name = "assets"
    managed_by = "terraform"
  }
}



output "id" {
  value = aws_s3_bucket.assets.id
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.assets.bucket_regional_domain_name
}
