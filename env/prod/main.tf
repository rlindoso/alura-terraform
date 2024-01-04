module "aws-prod" {
  source = "../../infra"
  instance = "t2.micro"
  aws_region = "us-east-2"
  sshKey = "IaC-PROD"
  securityGroup = "prod_access"
  securityGroupDesc = "Prod access"
  autoscalingGroupMinSize = 1
  autoscalingGroupMaxSize = 5
  autoscalingGroupName = "Prod"
  production = true
}
