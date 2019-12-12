output "vpc_id" {
  value = module.vpc.vpc_id
  description = "ID of the generated VPC e.g. vpc-1234567890"
}

output "subnets" {
  value = module.vpc.public_subnets
  description = "List of the public subnets created in the VPC"
}
