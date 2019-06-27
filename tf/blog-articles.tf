resource "aws_s3_bucket" "blog_articles_assets" {
  bucket = "${var.env}-blog-articles-assets"

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket_policy" "blog_articles_assets" {
  bucket = "${aws_s3_bucket.blog_articles_assets.id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.blog_articles_assets.id}/*"
            ],
            "Effect": "Allow",
            "Principal": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_user" "blog_articles" {
  name = "${var.env}-blog-articles"
  path = "/applications/"
}

resource "aws_iam_access_key" "blog_articles" {
  user    = "${aws_iam_user.blog_articles.name}"
  pgp_key = "${file("libero-admin.pub")}"
}

output "credentials_blog_articles_id" {
  value = "${aws_iam_access_key.blog_articles.id}"
}

output "credentials_blog_articles_secret" {
  value = "${aws_iam_access_key.blog_articles.encrypted_secret}"
}

resource "aws_iam_policy" "blog_articles_s3_write" {
  name        = "${var.env}BlogArticlesS3Write"
  path        = "/applications/"
  description = "Allows read and write access to blog-articles-assets S3 storage"

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
                "arn:aws:s3:::${aws_s3_bucket.blog_articles_assets.id}",
                "arn:aws:s3:::${aws_s3_bucket.blog_articles_assets.id}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "blog_articles_s3_write" {
  user       = "${aws_iam_user.blog_articles.name}"
  policy_arn = "${aws_iam_policy.blog_articles_s3_write.arn}"
}
