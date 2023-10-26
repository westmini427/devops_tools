terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-2"
}


# resource : 리소스를 새로 생성할 때
# data : 기존 리소스를 가져올 때, 가상으로 데이터를 정의할 때

data "aws_vpc" "default" {
  filter {
    name   = "is-default"
    values = [true]
  }
}


resource "aws_security_group" "hello" {
  name   = "hello"
  vpc_id = data.aws_vpc.default.id

  ingress {
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
    Name = "hello"
  }
}


resource "aws_instance" "helloworld" {
  ami           = "ami-086cae3329a3f7d75"
  instance_type = "t3.micro"

  key_name        = "aws_seo"
  security_groups = [aws_security_group.hello.name]

  user_data = file("${path.module}/userdata.yaml")

  tags = {
    Name = "hello"
  }
}

