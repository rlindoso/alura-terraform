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

resource "aws_launch_template" "machine" {
  image_id = "ami-024e6efaf93d85776"
  instance_type = var.instance
  key_name      = var.sshKey
  tags = {
    Name = "Terraform Ansible Pyhton"
  }
  security_group_names = [var.securityGroup]
  user_data = var.production ? ("ansible.sh") : ""
}

resource "aws_key_pair" "chaveSSH" {
  key_name = var.sshKey
  public_key = file("${var.sshKey}.pub")
}

resource "aws_autoscaling_group" "autoscalingGroup" {
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  name = var.autoscalingGroupName
  max_size = var.autoscalingGroupMaxSize
  min_size = var.autoscalingGroupMinSize
  launch_template {
    id = aws_launch_template.machine.id
    version = "$Latest"
  }
  target_group_arns = var.production ? [ aws_lb_target_group.loadBalancerTargetGroup[0].arn ] : []
}

resource "aws_autoscaling_schedule" "ScheduleToProvideResource" {
  scheduled_action_name  = "ScheduleToProvideResource"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 1
  start_time             = timeadd(timestamp(), "10m")
  recurrence             = "0 10 * * MON-FRI"
  autoscaling_group_name = aws_autoscaling_group.autoscalingGroup.name
}

resource "aws_autoscaling_schedule" "ScheduleToRemoveResource" {
  scheduled_action_name  = "ScheduleToRemoveResource"
  min_size               = 0
  max_size               = 1
  desired_capacity       = 0
  start_time             = timeadd(timestamp(), "11m")
  recurrence             = "0 21 * * MON-FRI"
  autoscaling_group_name = aws_autoscaling_group.autoscalingGroup.name
}

resource "aws_default_subnet" "subnet_a" {
  availability_zone =  "${var.aws_region}a"
}

resource "aws_default_subnet" "subnet_b" {
  availability_zone =  "${var.aws_region}b"
}

resource "aws_lb" "loadBalancer" {
  internal = false
  subnets = [ aws_default_subnet.subnet_a.id, aws_default_subnet.subnet_b.id ]
  count = var.production ? 1 : 0
}

resource "aws_default_vpc" "vpcDefault" {
  
}

resource "aws_lb_target_group" "loadBalancerTargetGroup" {
  name = "TargetMachines"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.vpcDefault.id
  count = var.production ? 1 : 0
}

resource "aws_lb_listener" "entryLoadBalancer" {
  load_balancer_arn = aws_lb.loadBalancer[0].arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.loadBalancerTargetGroup[0].arn
  }
  count = var.production ? 1 : 0
}

resource "aws_autoscaling_policy" "autoscalingPolicy" {
  name = "autoscalingPolicy"
  autoscaling_group_name = var.autoscalingGroupName
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
  count = var.production ? 1 : 0
}