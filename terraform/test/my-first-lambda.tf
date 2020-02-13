variable "app_version" {
}

resource "aws_lambda_function" "deployer" {
  function_name = "deploy_test"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "immutable-webapp-deploy-src"
  s3_key    = "v${var.app_version}/src.zip"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "main.handler"
  runtime = "nodejs10.x"

  role = aws_iam_role.lambda_exec.arn
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
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::tf-immutable-webapp-test/*"
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
