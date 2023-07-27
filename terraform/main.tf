# Define the AWS provider and specify the region as us-east-1
provider "aws" {
  region = "us-east-1"
}

# Fetch the latest Amazon Linux AMI filtered by its name
data "aws_ami" "websrv_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Fetch available AWS availability zones for the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Fetch the default AWS VPC (Virtual Private Cloud)
data "aws_vpc" "default" {
  default = true
}

# Create an AWS EC2 instance resource
resource "aws_instance" "web_server" {
  ami                  = data.aws_ami.websrv_amazon_linux.id
  key_name             = aws_key_pair.assignment1.key_name
  subnet_id            = aws_subnet.public_subnet.id
  instance_type        = var.instance_type
  iam_instance_profile = "LabInstanceProfile"
  security_groups      = [aws_security_group.web_sg.id]

  # Define tags for the instance
  tags = merge({
    Name = "${var.prefix}-WebServer"
    }
  )
}

# Create an AWS key pair resource used for SSH access
resource "aws_key_pair" "assignment1" {
  key_name   = var.prefix
  public_key = file("assignment1.pub")
}

# Create a public subnet in the default VPC with a non-conflicting CIDR block
resource "aws_subnet" "public_subnet" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.128.0/20"  # Choose a non-overlapping CIDR block for the new subnet
  map_public_ip_on_launch = true

  # Define tags for the subnet
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-Public-Subnet"
    }
  )
}

# Create a security group for the web server instances
resource "aws_security_group" "web_sg" {
  name        = "webserver-SG"
  description = "SG for web server"
  vpc_id      = data.aws_vpc.default.id

  # Allow incoming HTTP traffic from everywhere
  ingress {
    description = "HTTP from everywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow incoming SSH traffic from everywhere
  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow incoming traffic on port 8081 from everywhere
  ingress {
    description = "HTTP from everywhere"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow incoming traffic on port 8082 from everywhere
  ingress {
    description = "HTTP from everywhere"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow incoming traffic on port 8083 from everywhere
  ingress {
    description = "HTTP from everywhere"
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outgoing traffic to everywhere
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Define tags for the security group
  tags = merge(
    var.default_tags, {
      Name = "${var.prefix}-WebSrv-SG"
    }
  )
}

/*
# Create an AWS Elastic Container Registry (ECR) repository for web server images
resource "aws_ecr_repository" "webserver_images" {
  name = "webserver_images-images"
}

# Create an AWS Elastic Container Registry (ECR) repository for MySQL images
resource "aws_ecr_repository" "mysql_images" {
  name = "mysql-images"
}
*/
