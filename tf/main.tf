resource "aws_instance" "unstable" {
  # This is the latest minimal version of Amazon Linux coupled with ECS container agent, Docker and ecs-init scripts
  # see https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
  ami             = "ami-00129b193dc81bc31"
  instance_type   = "t2.micro"

  tags {
    Name = "unstable"
  }
}