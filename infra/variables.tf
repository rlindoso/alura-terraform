variable "aws_region" {
  type = string
}

variable "sshKey" {
  type = string
}

variable "instance" {
  type = string
}

variable "securityGroup" {
  type = string
}

variable "securityGroupDesc" {
  type = string
}

variable "autoscalingGroupName" {
  type = string
}

variable "autoscalingGroupMaxSize" {
  type = number
}

variable "autoscalingGroupMinSize" {
  type = number
}

variable "production" {
  type = bool  
}