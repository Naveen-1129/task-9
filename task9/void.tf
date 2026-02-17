provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web" {
  count = 5
  ami           = "ami-0c1fe732b5494dc14"
  instance_type = "t2.micro"
  key_name = "testkey"
       tags = {
    Name = "task9"
  }
}
