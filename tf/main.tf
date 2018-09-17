resource "aws_instance" "single_node" {

  # us-east-1 bionic 18.04 LTS amd64 hvm:ebs-ssd 20180912                    
  # https://cloud-images.ubuntu.com/locator/ec2/
  ami = "ami-0ac019f4fcb7cb7e6"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = ["${aws_security_group.single_node.id}"]
  associate_public_ip_address = true
  key_name = "${aws_key_pair.single_node.key_name}"

  tags {
    Name = "single-node--${var.env}"
  }

  provisioner "remote-exec" {
    script = "install-docker.sh"

    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = "${file("single-node--${var.env}.key")}"
    }
  }
}

output "single_node_ip" {
  value = "${aws_instance.single_node.public_ip}"
}

output "single_node_key_name" {
  value = "${aws_instance.single_node.key_name}"
}

resource "aws_security_group" "single_node" {
  name = "single_node_ssh_http"
  lifecycle {
    create_before_destroy = true
  }
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

resource "aws_key_pair" "single_node" {
  key_name   = "single-node--${var.env}"
  public_key = "${data.local_file.public_key.content}"
}

data "local_file" "public_key" {
  filename = "single-node--${var.env}.key.pub"
}

