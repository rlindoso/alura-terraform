terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

resource "aws_instance" "app_test_terraform" {
  ami           = "ami-024e6efaf93d85776"
  instance_type = var.instance
  key_name      = var.sshKey
  tags = {
    Name = "Terraform Ansible Pyhton"
  }
}

resource "aws_key_pair" "chaveSSH" {
  key_name = var.sshKey
  public_key = file("${var.sshKey}.pub")
}