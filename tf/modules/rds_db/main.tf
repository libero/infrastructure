resource "aws_db_subnet_group" "rds_subnet_group" {
  subnet_ids = var.subnet_ids
}

resource "random_password" "db_password" {
  length = 50
}

resource "aws_security_group" "allow_internal_traffic" {
  name = "allow_internal_traffic_${var.database_id}"
  description = "Allow interal inbound traffic"
  vpc_id = var.vpc_id
  ingress {
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    security_groups = [var.security_group_id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "db_instance" {
  identifier = var.database_id
  skip_final_snapshot = true
  allocated_storage = 20
  engine = "postgres"
  engine_version = "11.5"
  instance_class = "db.t2.micro"
  name = var.database_name
  username = var.username
  password = random_password.db_password.result
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.allow_internal_traffic.id]
}
