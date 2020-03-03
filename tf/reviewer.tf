resource "aws_s3_bucket" "reviewer_storybook" {
  bucket = "${var.env}-reviewer-storybook"

  tags = {
    Environment = var.env
  }
}

resource "aws_s3_bucket_policy" "reviewer_storybook" {
  bucket = aws_s3_bucket.reviewer_storybook.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.reviewer_storybook.id}/*"
            ],
            "Effect": "Allow",
            "Principal": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_policy" "reviewer_travis_ci_s3" {
  name        = "${var.env}ReviewerTravisCiS3"
  path        = "/applications/"
  description = "Allows read and write access to Reviewer Travis CI S3 storage"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListAllMyBuckets"
            ],
            "Resource": ["*"]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::${var.env}-reviewer-storybook",
                "arn:aws:s3:::${var.env}-reviewer-storybook/*"
            ]
        }
    ]
}
POLICY
}

resource "aws_iam_user" "reviewer_travis_ci" {
  name = "${var.env}-reviewer-travis-ci"
  path = "/applications/"
}

resource "aws_iam_access_key" "reviewer_travis_ci" {
  user = aws_iam_user.reviewer_travis_ci.name
  pgp_key = file("libero-admin.pub")
}

output "credentials_reviewer_travis_ci_id" {
    value = aws_iam_access_key.reviewer_travis_ci.id
}

output "credentials_reviewer_travis_ci_secret" {
    value = aws_iam_access_key.reviewer_travis_ci.encrypted_secret
}

resource "aws_iam_user_policy_attachment" "reviewer_travis_ci_s3" {
  user       = aws_iam_user.reviewer_travis_ci.name
  policy_arn = aws_iam_policy.reviewer_travis_ci_s3.arn
}
