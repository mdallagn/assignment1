provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "websrv_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "web_server" {
  ami                  = data.aws_ami.websrv_amazon_linux.id
  key_name             = aws_key_pair.assignment1.key_name
  subnet_id            = aws_subnet.public_subnet.id
  instance_type        = var.instance_type
  iam_instance_profile = "LabInstanceProfile"
  security_groups      = [aws_security_group.web_sg.id]
  tags = merge({
    Name = "${var.prefix}-WebServer"
    }
  )
}

resource "aws_key_pair" "assignment1" {
  key_name   = var.prefix
  public_key = file("assignment1.pub")
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = var.public_subnet_cidrs
  map_public_ip_on_launch = true
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-Public-Subnet"
    }
  )
}

resource "aws_security_group" "web_sg" {
  name        = "websrv-SG"
  description = "SG for web server"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from everywhere"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from everywhere"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from everywhere"
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-WebSrv-SG"
    }
  )
}

resource "aws_ecr_repository" "websrv_images" {
  name = "websrv-images"
}

resource "aws_ecr_repository" "mysql_images" {
  name = "mysql-images"
}
