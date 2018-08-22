variable "region" {
  default = "us-east-1"
  description = "The AWS region."
}

variable "env" {
  default = "unstable"
  description = "Environment: dev, prod, end2end"
}

variable "org" {
  default = "Libero"
  description = "Organisation. Useful for S3 bucket naming."
}

variable "account_id" {
  default = "540790251273"
  description = "AWS account ID."
}

variable "aws_access_key" {
  # set using command time e.g. terraform apply -var 'access_key=foo'
  default = "YOUR_ADMIN_ACCESS_KEY"
}

variable "aws_secret_key" {
  # set using command time e.g. terraform apply -var 'access_key=foo'
  default = "YOUR_ADMIN_SECRET_KEY"
}