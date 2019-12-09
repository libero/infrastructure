resource "aws_s3_bucket" "blog_articles_assets" {
  count = var.create_single_node_architecture ? 1 : 0
  bucket = "${var.env}-blog-articles-assets"

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket_policy" "blog_articles_assets" {
  count = var.create_single_node_architecture ? 1 : 0
  bucket = "${aws_s3_bucket.blog_articles_assets[count.index].id}"

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.blog_articles_assets[count.index].id}/*"
            ],
            "Effect": "Allow",
            "Principal": "*"
        }
    ]
}
POLICY
}

resource "aws_iam_user" "blog_articles" {
  count = var.create_single_node_architecture ? 1 : 0
  name = "${var.env}-blog-articles"
  path = "/applications/"
}

resource "aws_iam_access_key" "blog_articles" {
  count = var.create_single_node_architecture ? 1 : 0
  user    = "${aws_iam_user.blog_articles[count.index].name}"
  pgp_key = "${file("libero-admin.pub")}"
}

output "credentials_blog_articles_id" {
  value = concat(aws_iam_access_key.blog_articles.*.id, [""])[0]
}

output "credentials_blog_articles_secret" {
  value = concat(aws_iam_access_key.blog_articles.*.encrypted_secret, [""])[0]
}

resource "aws_iam_policy" "blog_articles_s3_write" {
  count = var.create_single_node_architecture ? 1 : 0
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
                "arn:aws:s3:::${aws_s3_bucket.blog_articles_assets[count.index].id}",
                "arn:aws:s3:::${aws_s3_bucket.blog_articles_assets[count.index].id}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "blog_articles_s3_write" {
  count = var.create_single_node_architecture ? 1 : 0
  user       = "${aws_iam_user.blog_articles[count.index].name}"
  policy_arn = "${aws_iam_policy.blog_articles_s3_write[count.index].arn}"
}
