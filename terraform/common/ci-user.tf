resource "aws_iam_user" "ci" {
  name = "tf-immutable-webapp-ci-user"

  tags = {
    type = "ci"
    origin = "github"
    managed_by = "terraform"
  }
}

resource "aws_iam_access_key" "ci_key" {
  user = aws_iam_user.ci.name
}

resource "aws_iam_policy" "bucket" {
  name        = "tf-AmazonS3FullAccess-${aws_s3_bucket.assets.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "${aws_s3_bucket.assets.arn}/*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "lambda" {
  name        = "tf-LambdaInvokeFunction-all"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "bucket" {
  user       = aws_iam_user.ci.name
  policy_arn = aws_iam_policy.bucket.arn
}

resource "aws_iam_user_policy_attachment" "lambda" {
  user       = aws_iam_user.ci.name
  policy_arn = aws_iam_policy.lambda.arn
}
