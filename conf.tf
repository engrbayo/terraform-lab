terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile ="default"
}

resource "aws_instance" "new-instance" {
  ami           = "ami-0c293f3f676ec4f90"
  instance_type = "t2.micro"
  count =3
  vpc_security_group_ids = [aws_security_group.instance-security.id]

}

resource "aws_security_group" "instance-security" {
  name        = "instance-security"
  description = "Allow TLS inbound traffic"

  ingress {
    description      = "Tcp"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  ingress {
    description      = "https"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "icmb"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc" "default-vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "default-subnet" {
  vpc_id     = aws_vpc.default-vpc.id
  cidr_block = var.subnet_cidr_block

  tags = {
    Name = "Main"
  }
}

variable "subnet_cidr_block" {
    description = "subnet-cidr-block"
    type = list(string)
}

