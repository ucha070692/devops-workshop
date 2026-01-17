provider "aws" {
  region = "eu-central-1"
}

resource "aws_security_group" "demo_sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id = aws_vpc.dpp-vpc.id

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
  ami           = "ami-004e960cde33f9146"
  instance_type = "t3.micro"
  key_name      = "dpp"
  subnet_id     = aws_subnet.dpp-public-subnet-01.id
  vpc_security_group_ids = [
    aws_security_group.demo_sg.id
  ]
for_each = toset(["jenkins-master", "build-slave", "ansible"])
  tags = {
    Name = "demo-server"
  }
}
resource "aws_vpc" "dpp-vpc" {
  cidr_block = "10.1.0.0/16"
  tags = ({
    Name = "dpp-vpc"
  })
  
}
resource "aws_subnet" "dpp-public-subnet-01" {
  vpc_id            = aws_vpc.dpp-vpc.id
  cidr_block        = "10.1.1.0/24" 
  map_public_ip_on_launch = true
  availability_zone = "eu-central-1a"
    tags = ({
        Name = "dpp-public-subnet-01"
    })
}

resource "aws_subnet" "dpp-public-subnet-02" {
  vpc_id            = aws_vpc.dpp-vpc.id
  cidr_block        = "10.1.2.0/24" 
  map_public_ip_on_launch = true
  availability_zone = "eu-central-1b"
    tags = ({
        Name = "dpp-public-subnet-02"
    })
}

resource "aws_internet_gateway" "dpp-igw" {
  vpc_id = aws_vpc.dpp-vpc.id
    tags = ({
        Name = "dpp-igw"
    })
}
resource "aws_route_table" "dpp-public-rt" {
  vpc_id = aws_vpc.dpp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dpp-igw.id
  }

    tags = ({
        Name = "dpp-public-rt"
    })
}
resource "aws_route_table_association" "dpp-rta-public-subnet-01" {
    subnet_id      = aws_subnet.dpp-public-subnet-01.id
    route_table_id = aws_route_table.dpp-public-rt.id
  
}
resource "aws_route_table_association" "dpp-rta-public-subnet-02" {
    subnet_id      = aws_subnet.dpp-public-subnet-02.id
    route_table_id = aws_route_table.dpp-public-rt.id
  
}