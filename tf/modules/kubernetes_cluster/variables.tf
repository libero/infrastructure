variable "cluster_name" {
  description = "Readable cluster name to give the cluster e.g. libero-eks--franklin"
}

variable "env" {
  description = "Name of the environment for tagging e.g. franklin, prod"
}

variable "vpc_id" {
  description = "ID of a VPC e.g vpc-1234567890"
}

variable "subnets" {
  description = "List of subnets coming from VPC module"
}

variable "map_users" {
  description = "IAM users that can access the cluster. See https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/basic/variables.tf#L32"
}
