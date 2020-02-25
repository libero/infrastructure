resource "aws_security_group" "node_port_services_public_access" {
  description = "Allows access to NodePort Services from the public internet"
  name_prefix = "node_port_services_public_access"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 30000
    to_port   = 32767
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "eks" {
  # master, unreleased 8.x
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=11d8ee8631ec2bb98d85295d814a4dc738026704"
  # TODO: transition to the following
  # when a 8.x release is available
  #source  = "terraform-aws-modules/eks/aws"
  #version = "7.0.0"

  cluster_name = var.cluster_name
  vpc_id = var.vpc_id
  subnets      = var.subnets

  worker_groups = [
    {
      name                          = "${var.cluster_name}--small"
      instance_type                 = "t2.small"
      asg_desired_capacity          = 2
    },
  ]
  worker_additional_security_group_ids = [aws_security_group.node_port_services_public_access.id]

  map_users                            = var.map_users

  write_kubeconfig = false
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
