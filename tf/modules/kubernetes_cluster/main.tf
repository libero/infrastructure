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

variable "map_users" {
  description = "IAM users that can access the cluster. See https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/basic/variables.tf#L32"
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

  map_users                            = var.map_users
}

#data "aws_eks_cluster" "cluster" {
#  name = module.eks.cluster_id
#}
#
#data "aws_eks_cluster_auth" "cluster" {
#  name = module.eks.cluster_id
#}
#
#provider "kubernetes" {
#  host                   = data.aws_eks_cluster.cluster.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#  token                  = data.aws_eks_cluster_auth.cluster.token
#  load_config_file       = false
#  version                = "~> 1.10"
#}

