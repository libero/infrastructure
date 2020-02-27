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

provider "local" {
  version = "~> 1.2"
}

resource "aws_db_subnet_group" "publisher__test_rds_article_store_postgresql" {
  subnet_ids = module.kubernetes_vpc.subnets
}

resource "random_password" "publisher__test_rds_article_store_postgresql_password" {
  length = 50
}

resource "aws_security_group" "allow_internal_traffic_postgresql" {
  name = "allow_internal_traffic_postgresql"
  description = "Allow interal inbound Postgres traffic"
  vpc_id = module.kubernetes_vpc.vpc_id
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [module.kubernetes_cluster.worker_security_group_id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "publisher__test_rds_article_store_postgresql" {
  identifier = "publisher-test-rds-article-store"
  skip_final_snapshot = true
  allocated_storage = 20
  engine = "postgres"
  engine_version = "11.5"
  instance_class = "db.t2.micro"
  name = "articlestore"
  username = "articlestore"
  password = random_password.publisher__test_rds_article_store_postgresql_password.result
  db_subnet_group_name = aws_db_subnet_group.publisher__test_rds_article_store_postgresql.name
  vpc_security_group_ids = [aws_security_group.allow_internal_traffic_postgresql.id]
}

resource "kubernetes_secret" "publisher__test_rds_article_store_postgresql" {
  metadata {
    name = "publisher--test-rds-article-store-postgresql"
  }
  data = {
    postgresql-database = aws_db_instance.publisher__test_rds_article_store_postgresql.name
    postgresql-username = aws_db_instance.publisher__test_rds_article_store_postgresql.username
    postgresql-password = aws_db_instance.publisher__test_rds_article_store_postgresql.password
    postgresql-host = aws_db_instance.publisher__test_rds_article_store_postgresql.address
    postgresql-port = aws_db_instance.publisher__test_rds_article_store_postgresql.port
  }
}
