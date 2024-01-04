module "aws-dev" {
  source = "../../infra"
  instance = "t2.micro"
  aws_region = "us-east-2"
  sshKey = "IaC-DEV"
  securityGroup = "dev_access"
  securityGroupDesc = "Dev access"
  autoscalingGroupMinSize = 0
  autoscalingGroupMaxSize = 1
  autoscalingGroupName = "Dev"
  production = false
}
