provider "aws" {
  region = "us-east-1" # Specify the region
}

resource "aws_instance" "aiwebmaven" {
  ami           = "ami-0b72821e2f351e396" # Amazon Linux 2 AMI (HVM), SSD Volume Type for us-east-1
  instance_type = "t2.micro"
  key_name      = "terraform"

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }

  vpc_security_group_ids = [aws_security_group.allow_all.id]

  associate_public_ip_address = true

  tags = {
    Name = "aiwebmaven"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "AllowAllTraffic"
  }
}
