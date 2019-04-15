resource "aws_s3_bucket" "elife_style_content_adapter_incoming" {
  bucket = "${var.env}-elife-style-content-adapter-incoming"
  acl    = "read-public"

  tags = {
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket" "elife_style_content_adapter_expanded" {
  bucket = "${var.env}-elife-style-content-adapter-expanded"
  acl    = "read-public"

  tags = {
    Environment = "${var.env}"
  }
}
