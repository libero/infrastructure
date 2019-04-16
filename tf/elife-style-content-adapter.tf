resource "aws_s3_bucket" "elife_style_content_adapter_incoming" {
  bucket = "${var.env}-elife-style-content-adapter-incoming"
  acl    = "public-read"

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

resource "aws_iam_user" "elife_style_content_adapter" {
  name = "${var.env}-elife-style-content-adapter"
  path = "/applications/"
}

resource "aws_iam_access_key" "elife_style_content_adapter" {
  user = "${aws_iam_user.elife_style_content_adapter.name}"
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
                "s3:DeleteObject",
                "s3:GetObject",
                "s3:ListAllMyBuckets",
                "s3:ListBucket",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.env}-elife-style-content-adapter-*",
                "arn:aws:s3:::${var.env}-elife-style-content-adapter-*/"
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
