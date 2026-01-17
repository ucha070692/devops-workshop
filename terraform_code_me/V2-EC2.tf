provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "demo_sg" {
  name        = "demo-sg"
  description = "SSH Access"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-protocol"
  }
}

resource "aws_instance" "demo_server" {
  ami           = "ami-0387413ed05eb20af"
  instance_type = "t3.micro"
  key_name      = "dpp"

  vpc_security_group_ids = [
    aws_security_group.demo_sg.id
  ]

  tags = {
    Name = "demo-server"
  }
}
