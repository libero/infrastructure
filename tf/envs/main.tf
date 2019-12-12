variable "region" {
  default = "us-east-1"
  description = "The AWS region."
}

variable "env" {
  description = "Environment: unstable, demo, ..."
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

module "kubernetes_vpc" {
  source = "../../modules/kubernetes_vpc"
  cluster_name = "libero-eks--${var.env}"
}

module "kubernetes_cluster" {
  source = "../../modules/kubernetes_cluster"
  cluster_name = "libero-eks--${var.env}"
  env = var.env
  vpc_id = module.kubernetes_vpc.vpc_id
  subnets = module.kubernetes_vpc.subnets
}

provider "local" {
  version = "~> 1.2"
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

