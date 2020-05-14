# could actually be limited to only creating logs, 
# but it's difficult to find a standard policy that covers
# all the actions that the CloudWatch agent may use
resource "aws_iam_role_policy" "logs_full_access" {
  role = var.role_name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
POLICY
}
