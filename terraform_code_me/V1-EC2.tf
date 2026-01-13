provider "aws" {
   region  = "eu-central-1"
   }
resource "aws_instance" "demo-server" {
  ami = "ami-0387413ed05eb20af"
  instance_type = "t2.micro"
  key_name = "dpp"
}