variable "cluster_name" {
}

variable "env" {
}

variable "vpc_id" {
}

variable "subnets" {
}

variable "map_users" {
  description = "IAM users that can access the cluster. See https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/basic/variables.tf#L32"
}

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
  source  = "terraform-aws-modules/eks/aws"
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

  # TODO: remove as obsolete when upgrading to 8.x
  # https://github.com/terraform-aws-modules/terraform-aws-eks/blob/11d8ee8631ec2bb98d85295d814a4dc738026704/CHANGELOG.md#v8---2019--
  write_aws_auth_config = false
  # end TODO
  write_kubeconfig = false
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.10"
}
