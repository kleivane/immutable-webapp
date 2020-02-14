locals {
  deployer_src_version = "0.0.6"
}

resource "aws_lambda_function" "deployer" {
  function_name = "deploy_test"

  s3_bucket = "immutable-webapp-deploy-src"
  s3_key    = "${local.deployer_src_version}/src.zip"

  handler = "main.handler"
  runtime = "nodejs10.x"

  role = aws_iam_role.lambda_exec.arn

  environment {
  variables = {
    TF_ENVIRONMENT = "test"
    TF_API_URL = module.immutable_cloudfront.distribution.domain_name
    TF_BUCKET = aws_s3_bucket.test.id
  }
}
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "deployer_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }]
}
EOF

}

resource "aws_iam_policy" "policy" {
  name        = "test-lambda-deployer-policy"
  description = "A policy for the lambda deploying to test"

  policy = <<EOF
{
  "Id": "Policy1581595644141",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1581595637934",
      "Action": [
        "s3:ListBucket",
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.test.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "test-lambda-deployer-attach" {
  name       = "test-lambda-deployer-attachment"
  roles      = ["${aws_iam_role.lambda_exec.name}"]
  policy_arn = aws_iam_policy.policy.arn
}
