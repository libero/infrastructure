provider "aws" {
  region = var.region
}

# Needed for the terraform-aws-eks module to create the aws-auth ConfigMap
provider "kubernetes" {
  host = module.kubernetes_cluster.kubernetes_config.host
  cluster_ca_certificate = module.kubernetes_cluster.kubernetes_config.cluster_ca_certificate
  token =  module.kubernetes_cluster.kubernetes_config.token
  load_config_file       = false
  version                = "~> 1.10"
}

provider "helm" {
  kubernetes {
    host = module.kubernetes_cluster.kubernetes_config.host
    cluster_ca_certificate = module.kubernetes_cluster.kubernetes_config.cluster_ca_certificate
    token =  module.kubernetes_cluster.kubernetes_config.token
    load_config_file = false
  }
  version = "~> 1.0"
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
  domain_name = "libero.pub"
  owner_id = "libero-eks--${var.env}"
}

module "publisher__test_rds_article_store" {
  source = "../../modules/rds_db"
  vpc_id = module.kubernetes_vpc.vpc_id
  subnet_ids = module.kubernetes_vpc.subnets
  security_group_id = module.kubernetes_cluster.worker_security_group_id
  database_id = "publisher-test-rds-article-store"
  database_name = "article_store"
  username = "articlestore"
}

provider "local" {
  version = "~> 1.2"
}

resource "kubernetes_secret" "publisher__test_rds_article_store_postgresql" {
  metadata {
    name = "publisher--test-rds-article-store-postgresql"
  }
  data = {
    postgresql-database = module.publisher__test_rds_article_store.database
    postgresql-username = module.publisher__test_rds_article_store.username
    postgresql-password = module.publisher__test_rds_article_store.password
    postgresql-host = module.publisher__test_rds_article_store.hostname
    postgresql-port = module.publisher__test_rds_article_store.port
  }
}
