provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# EC2 instance
resource "aws_instance" "webserver" {
  ami           = "ami-076309742d466ad69"
  instance_type = "t2.micro"

  # Add SG for EC2
  security_groups = [aws_security_group.sg-webserver.name]
  # Add public key for EC2
  key_name  = "linuxkey"
  user_data = file("file.sh")

  tags = {
    "Name" = "AWS-Linux-Server"
  }
}

# Security Group
resource "aws_security_group" "sg-webserver" {
  name = "Allow all"

  # Inbound
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "SG-Webserver"
  }
}

# EIP
resource "aws_eip" "elasticip" {
  instance = aws_instance.webserver.id
}

# Output EIP
output "eip" {
  value = aws_eip.elasticip.public_ip
}
