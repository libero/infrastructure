variable "region" {
  default = "us-east-1"
  description = "The AWS region."
}

variable "env" {
  description = "Environment: unstable, demo, ..."
}

variable "vpc_id" {
  default = "vpc-e121f79b"
  description = "Default VPC for us-east-1 on Libero account"
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "libero-terraform"
    # specify with terraform init --backend-config="key=<env>/terraform.tfstate" to make it dynamic
    #key    = "unstable/terraform.tfstate"
    region = "us-east-1"
  }
  required_version = ">= 0.12.0"
}

module "kubernetes_cluster" {
  source = "../../modules/kubernetes_cluster"
  vpc_id = var.vpc_id
  name = "${var.env}--kubernetes-test" 
}
