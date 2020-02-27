variable "database_name" {
  description = "Name of the database to create, e.g. my_database"
}

variable "database_id" {
  description = "Name of the RDS instance to create, e.g. my-database"
}

variable "security_group_id" {
  description = "Security group ID, e.g. sg-018caeb91524d23ff"
}

variable "subnet_ids" {
  description = "List of the public subnets in the VPC"
}

variable "username" {
  description = "Name of the user to create, e.g. myuser"
}

variable "vpc_id" {
  description = "ID of the VPC, e.g. vpc-1234567890"
}
