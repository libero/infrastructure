variable "cluster_name" {
}

variable "env" {
}

variable "vpc_id" {
  default = "vpc-e121f79b"
  description = "Default VPC for us-east-1 on Libero account"
}

variable "subnets" {
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      "10.0.0.0/8",
      "172.16.0.0/12",
      "192.168.0.0/16",
    ]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  cluster_name = var.cluster_name
  vpc_id = var.vpc_id
  subnets      = var.subnets

  worker_groups = [
    {
      name                          = "${var.cluster_name}--small"
      instance_type                 = "t2.small"
      asg_desired_capacity          = 2
      additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]
    },
  ]

#  map_roles                            = var.map_roles
#  map_users                            = var.map_users
#  map_accounts                         = var.map_accounts
}
