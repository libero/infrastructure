resource "aws_instance" "unstable" {
  ami             = "ami-00129b193dc81bc31"
  instance_type   = "t2.micro"

  tags {
    Name = "unstable"
  }
}