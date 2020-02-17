output "bucket_id_asset" {
  value = module.immutable_cloudfront.bucket_id
}

output "bucket_prod" {
  value = aws_s3_bucket.prod.id
}

output "domain_name_prod" {
  value = module.immutable_cloudfront.distribution.domain_name
}

output "deploy_function" {
  value = module.deployer.name
}
