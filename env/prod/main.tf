module "aws-prod" {
  source = "../../infra"
  instance = "t2.micro"
  aws_region = "us-east-2"
  sshKey = "IaC-PROD"
  securityGroup = "prod_access"
  securityGroupDesc = "Prod access"
}

output "prod_ip" {
  value = module.aws-prod.public_ip
}