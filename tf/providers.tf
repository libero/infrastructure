provider "aws" {
  region = "${var.region}"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

terraform {
  backend "s3" {
    bucket = "libero-terraform"
    key    = "${var.env}/terraform.tfstate"
    region = "${var.region}"
  }
}