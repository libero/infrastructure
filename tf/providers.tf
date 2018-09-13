provider "aws" {
  region = "${var.region}"
}

provider "local" {
}

terraform {
  backend "s3" {
    bucket = "libero-terraform"
    # specify with terraform init --backend-config="key=unstable/terraform.tfstate" to make it dynamic
    #key    = "unstable/terraform.tfstate"
    region = "us-east-1"
  }
}
