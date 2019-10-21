resource "aws_s3_bucket" "jats_ingester_incoming" {
  bucket = "${var.env}-jats-ingester-incoming"

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket" "jats_ingester_expanded" {
  bucket = "${var.env}-jats-ingester-expanded"
  acl    = "public-read"

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket" "jats_ingester_completed_tasks" {
  bucket = "${var.env}-jats-ingester-completed-tasks"

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket" "jats_ingester_logs" {
  bucket = "${var.env}-jats-ingester-logs"

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket_policy" "jats_ingester_expanded" {
  bucket = "${aws_s3_bucket.jats_ingester_expanded.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.jats_ingester_expanded.id}/*"
            ],
            "Effect": "Allow",
            "Principal": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_user" "jats_ingester" {
  name = "${var.env}-jats-ingester"
  path = "/applications/"
}

resource "aws_iam_access_key" "jats_ingester" {
  user = "${aws_iam_user.jats_ingester.name}"
  pgp_key = "${file("libero-admin.pub")}"
}

output "credentials_jats_ingester_id" {
    value = "${aws_iam_access_key.jats_ingester.id}"
}

output "credentials_jats_ingester_secret" {
    value = "${aws_iam_access_key.jats_ingester.encrypted_secret}"
}

resource "aws_iam_policy" "jats_ingester_s3_write" {
  name        = "${var.env}JatsIngesterS3Write"
  path        = "/applications/"
  description = "Allows read and write access to jats-ingester S3 storage"

  policy = <<EOF
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
                "arn:aws:s3:::${var.env}-jats-ingester-*",
                "arn:aws:s3:::${var.env}-jats-ingester-*/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "jats_ingester_s3_write" {
  user       = "${aws_iam_user.jats_ingester.name}"
  policy_arn = "${aws_iam_policy.jats_ingester_s3_write.arn}"
}
