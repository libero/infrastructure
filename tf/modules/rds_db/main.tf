resource "random_pet" "db_name" {
  length = 2
  prefix = "database"
  separator = ""
  keepers = {
    database_id = var.database_id
  }
}

resource "random_pet" "db_user" {
  length = 2
  prefix = "user"
  separator = ""
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
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "db_instance" {
  name = "allow_internal_traffic_${var.database_id}"
  description = "Allow internal inbound traffic"
  vpc_id = var.vpc_id
}

resource "aws_security_group_rule" "db_instance_ingress" {
  type = "ingress"
  security_group_id = aws_security_group.db_instance.id
  from_port = aws_db_instance.db_instance.port
  to_port = aws_db_instance.db_instance.port
  protocol = "tcp"
  source_security_group_id = var.accessing_security_group_id
}

resource "aws_security_group_rule" "db_instance_egress" {
  type = "egress"
  security_group_id = aws_security_group.db_instance.id
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_db_instance" "db_instance" {
  identifier = var.database_id
  skip_final_snapshot = true
  allocated_storage = 20
  engine = "postgres"
  engine_version = "11.5"
  instance_class = "db.t2.micro"
  name = random_pet.db_name.id
  username = random_pet.db_user.id
  password = random_password.db_password.result
  db_subnet_group_name = aws_db_subnet_group.db_instance.name
  vpc_security_group_ids = [aws_security_group.db_instance.id]
}
