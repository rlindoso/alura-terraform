module "aws-dev" {
  source = "../../infra"
  instance = "t2.micro"
  aws_region = "us-east-2"
  sshKey = "IaC-DEV"
}