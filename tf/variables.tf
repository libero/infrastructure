variable "region" {
  default = "us-east-1"
  description = "The AWS region."
}

variable "env" {
  default = "unstable"
  description = "Environment: unstable, stable, ..."
}

variable "org" {
  default = "libero"
  description = "Organisation. Useful for S3 bucket naming."
}

variable "account_id" {
  default = "540790251273"
  description = "AWS account ID."
}

variable "vpc_id" {
  default = "vpc-e121f79b"
  description = "Default VPC for us-east-1 on Libero account"
}

variable "subnet_id" {
  default = "subnet-cec2bec1"
  description = "Default for us-east-1f on Libero account"
}
