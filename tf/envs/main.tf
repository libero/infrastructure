provider "aws" {
  region = var.region
}

data "aws_route53_zone" "main" {
  name = "libero.pub."
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
  map_users = var.map_users
}

module "kubernetes_dns" {
  source = "../../modules/kubernetes_dns"
  role_name = module.kubernetes_cluster.worker_iam_role_name
  hosted_zone_id = data.aws_route53_zone.main.zone_id
}

provider "local" {
  version = "~> 1.2"
}
