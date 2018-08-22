resource "aws_instance" "unstable" {
  # This is the latest minimal version of Amazon Linux coupled with ECS container agent, Docker and ecs-init scripts
  # see https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
  ami             = "ami-00129b193dc81bc31"
  instance_type   = "t2.micro"
  subnet_id = "${aws_subnet.main.id}"
  associate_public_ip_address = true

  tags {
    Name = "unstable EC2 Instance"
  }
}

resource "aws_vpc" "unstable" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "unstable VPC"
  }
}

resource "aws_subnet" "main" {
  cidr_block = "${var.subnet}"
  vpc_id = "${aws_vpc.unstable.id}"

  tags {
    Name = "Main Subnet"
  }
}

resource "aws_security_group" "vpc" {
  name = "vpc_sc"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.unstable.id}"

  tags {
    Name = "vpc_sg"
  }
}

resource "aws_eip" "publicIP" {
  instance = "${aws_instance.unstable}"
  vpc = true
}