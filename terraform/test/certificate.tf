provider "aws" {
  alias  = "certificate_region"
  region = "us-east-1"
}


resource "aws_acm_certificate" "primary" {
  domain_name       = local.url
  validation_method = "DNS"

  tags = {
    Environment = local.environment
  }

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.certificate_region
}

resource "aws_route53_record" "certificate_validation" {
  name    = aws_acm_certificate.primary.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.primary.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.primary.id
  records = [aws_acm_certificate.primary.domain_validation_options.0.resource_record_value]
  ttl     = 300
}

resource "aws_acm_certificate_validation" "primary" {
  certificate_arn         = aws_acm_certificate.primary.arn
  validation_record_fqdns = [aws_route53_record.certificate_validation.fqdn]
  provider                = aws.certificate_region

}
