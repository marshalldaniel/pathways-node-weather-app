################################################################################
# Define variables
################################################################################
variable "set_username_prefix" {}
# variable "vpc_id" {
  #pull from ssm parameter store. need to implement storage as well, unless this is deployed in environment as well
# }

################################################################################
### Security Groups
################################################################################

#hard code vpc id for testing
locals {
    vpc_id = "vpc-02256d210cdecca76"
}

resource "aws_security_group" "set_alb_sg" {
  name = "weather-app-alb-sg"
  description = "weather-app-alb-sg"
  vpc_id = local.vpc_id

  ingress {
    description = "Internet Web Traffic"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "set_ecs_sg" {
  name = "weather-app-ecs-sg"
  description = "weather-app-ecs-sg"
  vpc_id = local.vpc_id

  ingress {
    description = "ALB to ECS traffic"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.set_alb_sg.id]
  }
}
