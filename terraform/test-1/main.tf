locals {
  env = "test"
}

# Opprett bucket for assets felles for alle miljøer
# https://www.terraform.io/docs/providers/aws/r/s3_bucket.html

resource "aws_s3_bucket" "assets" {
  bucket = "tf-2-assets"
  acl    = "public-read"

  tags = {
    system        = "immutable-webapp"
    environment   = "common"
    managed_by    = "terraform"
  }
}

# Opprett bucket for testmiljø som skal serve index.html


resource "aws_s3_bucket" "host" {
  bucket = "tf-2-host-${local.env}"
  acl    = "public-read"

  tags = {
    system        = "immutable-webapp"
    environment   = local.env
    managed_by    = "terraform"
  }
}

# cloudformation

resource "aws_cloudfront_distribution" "cloudfront_env" {
  origin {
    domain_name = aws_s3_bucket.host.bucket_domain_name
    origin_id   = aws_s3_bucket.host.id
  }

  origin {
    domain_name = aws_s3_bucket.assets.bucket_domain_name
    origin_id   = aws_s3_bucket.assets.id
  }

  # Se https://github.com/terraform-providers/terraform-provider-aws/issues/1994 beskrivelse av "use origin headers"
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }


# egen bucket for index.html	    target_origin_id       = aws_s3_bucket.host.id
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern    = "assets/*"
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }

    target_origin_id       = aws_s3_bucket.assets.id
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled             = true
  comment             = local.env
  default_root_object = "index.html"


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }


  tags = {
    environment = local.env
    system        = "immutable-webapp"
    managed_by    = "terraform"
  }

  viewer_certificate {
    cloudfront_default_certificate  = true
  }
}

output assets{
  value       = aws_s3_bucket.host.bucket_domain_name
  description = "bucket domain name for test'"
}

output distribution {
  value       = aws_cloudfront_distribution.cloudfront_env.domain_name
  description = "Domain name for distribution'"
}
