output "database" {
  value = aws_db_instance.db_instance.name
  description = "Database name"
}

output "hostname" {
  value = aws_db_instance.db_instance.address
  description = "Database hostname"
}

output "password" {
  value = aws_db_instance.db_instance.password
  description = "Database password"
}

output "port" {
  value = aws_db_instance.db_instance.port
  description = "Database port"
}

output "username" {
  value = aws_db_instance.db_instance.username
  description = "Database username"
}
