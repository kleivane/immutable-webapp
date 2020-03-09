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
      "Resource": "${bucket_arn}/*"
    }
  ]
}
