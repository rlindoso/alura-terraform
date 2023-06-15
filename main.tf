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
  region  = "us-east-2"
}

resource "aws_instance" "app_test_terraform" {
  ami           = "ami-024e6efaf93d85776"
  instance_type = "t2.micro"
  key_name      = "terraform-key"
  # user_data     = <<-EOF
  #                    #!/bin/bash
  #                    cd /home/ubuntu
  #                    echo "<h1>Learning terraform</h1>" > index.html
  #                    nohup busybox httpd -f -p 8080 &
  #                    EOF
  tags = {
    Name = "Terraform Ansible Pyhton"
  }
}