resource "aws_instance" "single_node" {
  # This is the latest minimal version of Amazon Linux coupled with ECS container agent, Docker and ecs-init scripts
  # see https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
  ami             = "ami-00129b193dc81bc31"
  instance_type   = "t2.micro"
  subnet_id = "${var.subnet_id}"
  associate_public_ip_address = true

  tags {
    Name = "single-node--${var.env}"
  }
}

output "single_node_ip" {
  value = "${aws_instance.single_node.public_ip}"
}

output "single_node_key_name" {
  value = "${aws_instance.single_node.key_name}"
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
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "single-node--${var.env}--security-group"
  }
}
