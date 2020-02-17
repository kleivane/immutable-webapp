

resource "aws_lambda_function" "deployer" {
  function_name = "deploy_${var.environment}"
  description = "A lambda that configures and deploys an interpolated index.html to environment: ${var.environment}"

  s3_bucket = "immutable-webapp-deploy-src"
  s3_key    = "${var.src_version}/src.zip"

  handler = "main.handler"
  runtime = "nodejs10.x"

  role = aws_iam_role.lambda_exec.arn

  environment {
  variables = {
    TF_ENVIRONMENT = var.environment
    TF_API_URL = var.api_url
    TF_BUCKET = var.bucket.id
  }
}
}

resource "aws_iam_role" "lambda_exec" {
  name = "tf-deploy_lambda_${var.environment}"

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
  name        = "tf-deploy-${var.environment}-policy"
  description = "A policy for the lambda deploying to ${var.environment}"

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
      "Resource": "${var.bucket.arn}/*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda-deployer-attach" {
  name       = "tf-deploy-${var.environment}"
  roles      = ["${aws_iam_role.lambda_exec.name}"]
  policy_arn = aws_iam_policy.policy.arn
}
