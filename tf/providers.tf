provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "libero-terraform"
    key    = "${var.env}/terraform.tfstate"
    region = "${var.region}"
  }
}