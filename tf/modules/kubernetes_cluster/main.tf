variable "vpc_id" {
  default = "vpc-e121f79b"
  description = "Default VPC for us-east-1 on Libero account"
}

variable "name" {
  default = ""
}

resource "aws_subnet" "kubernetes_a" {
  vpc_id     = var.vpc_id
  cidr_block = "172.31.96.0/20"

  tags = {
    Name = "${var.name}"
  }
}
