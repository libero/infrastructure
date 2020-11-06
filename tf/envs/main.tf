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

provider "kubernetes-alpha" {
  host = module.kubernetes_cluster.kubernetes_config.host
  cluster_ca_certificate = module.kubernetes_cluster.kubernetes_config.cluster_ca_certificate
  token =  module.kubernetes_cluster.kubernetes_config.token
  version = "~> 0.2"
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
  domain_name = "sciety.org"
  owner_id = "libero-eks--${var.env}"
}

module "kubernetes_logs" {
  source = "../../modules/kubernetes_logs"
  cluster_name = "libero-eks--${var.env}"
  role_name = module.kubernetes_cluster.worker_iam_role_name
}

module "kubernetes_ingress" {
  source = "../../modules/kubernetes_ingress"
}

module "kubernetes_cert_manager" {
  source = "../../modules/kubernetes_cert_manager"
}

module "hive_staging_rds" {
  source = "../../modules/rds_db"
  database_id = "hive-staging-postgres"
  accessing_security_group_id = module.kubernetes_cluster.worker_security_group_id
  vpc_id = module.kubernetes_vpc.vpc_id
  subnet_ids = module.kubernetes_vpc.subnets
}

resource "kubernetes_secret" "hive_staging_rds_postgres" {
  metadata {
    name = "hive-staging-rds-postgres"
  }
  data = {
    postgresql-database = module.hive_staging_rds.database
    postgresql-username = module.hive_staging_rds.username
    postgresql-password = module.hive_staging_rds.password
    postgresql-host = module.hive_staging_rds.hostname
    postgresql-port = module.hive_staging_rds.port
  }
}

module "hive_prod_rds" {
  source = "../../modules/rds_db"
  database_id = "hive-prod-postgres"
  accessing_security_group_id = module.kubernetes_cluster.worker_security_group_id
  vpc_id = module.kubernetes_vpc.vpc_id
  subnet_ids = module.kubernetes_vpc.subnets
}

resource "kubernetes_secret" "hive_prod_rds_postgres" {
  metadata {
    name = "hive-prod-rds-postgres"
  }
  data = {
    postgresql-database = module.hive_prod_rds.database
    postgresql-username = module.hive_prod_rds.username
    postgresql-password = module.hive_prod_rds.password
    postgresql-host = module.hive_prod_rds.hostname
    postgresql-port = module.hive_prod_rds.port
  }
}
