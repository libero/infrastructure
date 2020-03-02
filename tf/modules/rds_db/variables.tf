variable "accessing_security_group_id" {
  description = "Security group ID of the accessing application, e.g. sg-018caeb91524d23ff"
}

variable "database_id" {
  description = "Name of the RDS instance to create, e.g. my-database"
}

variable "subnet_ids" {
  description = "List of the public subnets in the VPC, e.g. subnet-09a4fcfc7693064fa, subnet-029a41f3fc89b5958"
}

variable "vpc_id" {
  description = "ID of the VPC, e.g. vpc-1234567890"
}
