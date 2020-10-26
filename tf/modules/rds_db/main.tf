resource "random_pet" "db_name" {
  length = 2
  prefix = "database"
  separator = "_"
  keepers = {
    database_id = var.database_id
  }
}

resource "random_pet" "db_user" {
  length = 2
  prefix = "user"
  separator = "_"
  keepers = {
    db_name = random_pet.db_name.id
  }
}

resource "random_password" "db_password" {
  length = 50
  override_special = "!#$%&*()-_=+[]{}<>:?"
  keepers = {
    db_user = random_pet.db_user.id
  }
}

resource "aws_db_subnet_group" "db_instance" {
  description = "Contains RDS instance ${var.database_id}"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "rds_${var.database_id}"
  }
}

resource "aws_security_group" "db_instance" {
  description = "Allow internal inbound, and all external, traffic to RDS instance ${var.database_id}"
  vpc_id = var.vpc_id
  tags = {
    Name = "rds_${var.database_id}"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "db_instance_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.db_instance.id
  source_security_group_id = var.accessing_security_group_id
  protocol = "tcp"
  from_port = aws_db_instance.db_instance.port
  to_port = aws_db_instance.db_instance.port
}

resource "aws_security_group_rule" "db_instance_egress" {
  type = "egress"
  security_group_id = aws_security_group.db_instance.id
  cidr_blocks = ["0.0.0.0/0"]
  protocol = "all"
  from_port = 0
  to_port = 0
}

resource "aws_db_instance" "db_instance" {
  identifier = var.database_id
  engine = "postgres"
  engine_version = "12.3"
  instance_class = "db.t2.micro"
  allocated_storage = 20
  name = random_pet.db_name.id
  username = random_pet.db_user.id
  password = random_password.db_password.result
  db_subnet_group_name = aws_db_subnet_group.db_instance.name
  vpc_security_group_ids = [aws_security_group.db_instance.id]
  skip_final_snapshot = true
  backup_retention_period = 7
}
