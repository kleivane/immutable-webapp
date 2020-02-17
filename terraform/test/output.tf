output "bucket_id_asset" {
  value = module.immutable_cloudfront.bucket_id
}

output "bucket_id_test" {
  value = aws_s3_bucket.test.id
}

output "domain_name_test" {
  value = module.immutable_cloudfront.distribution.domain_name
}

output "deploy_function" {
  value = module.deployer.name
}
