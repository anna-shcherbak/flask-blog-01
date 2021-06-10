terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}


terraform {
  backend "s3" {
    bucket = "terraform-bucket-myproject"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

# Creation of  aws_security_group

variable "ingressrules" {
  type    = list(number)
  default = [80, 22]
}

resource "aws_security_group" "security_group_production" {
  name        = "Allow traffic to prod"
  description = "Allow ssh and 80 ports inbound and everything outbound"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressrules
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" = "true"
  }
}


data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

# Creation of production server
resource "aws_instance" "production_instance" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.security_group_production.name]
  key_name        = "jenkins_instance"
  user_data       = file("prod_instance.sh")
  tags = {
    "Name"      = "Production_Server"
    "Terraform" = "true"
  }
}
