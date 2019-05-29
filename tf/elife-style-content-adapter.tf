resource "aws_s3_bucket" "elife_style_content_adapter_incoming" {
  bucket = "${var.env}-elife-style-content-adapter-incoming"

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket" "elife_style_content_adapter_expanded" {
  bucket = "${var.env}-elife-style-content-adapter-expanded"
  acl    = "public-read"

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket_policy" "elife_style_content_adapter_expanded" {
  bucket = "${aws_s3_bucket.elife_style_content_adapter_expanded.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.elife_style_content_adapter_expanded.id}/*"
            ],
            "Effect": "Allow",
            "Principal": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_user" "elife_style_content_adapter" {
  name = "${var.env}-elife-style-content-adapter"
  path = "/applications/"
}

resource "aws_iam_access_key" "elife_style_content_adapter" {
  user = "${aws_iam_user.elife_style_content_adapter.name}"
  pgp_key = "${file("libero-admin.pub")}"
}

output "credentials_elife_style_content_adapter_id" {
    value = "${aws_iam_access_key.elife_style_content_adapter.id}"
}

output "credentials_elife_style_content_adapter_secret" {
    value = "${aws_iam_access_key.elife_style_content_adapter.encrypted_secret}"
}

resource "aws_iam_policy" "elife_style_content_adapter_s3_write" {
  name        = "ElifeStyleContentAdapterS3Write"
  path        = "/"
  description = "Allows read and write access to elife-style-content-adapter S3 storage"

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
                "arn:aws:s3:::${var.env}-elife-style-content-adapter-*",
                "arn:aws:s3:::${var.env}-elife-style-content-adapter-*/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "elife_style_content_adapter_s3_write" {
  user       = "${aws_iam_user.elife_style_content_adapter.name}"
  policy_arn = "${aws_iam_policy.elife_style_content_adapter_s3_write.arn}"
}
