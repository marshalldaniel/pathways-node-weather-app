################################################################################
# Define variables
################################################################################
variable "set_username_prefix" {}
variable "set_project_path" {}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.set_username_prefix}/${var.set_project_path}/vpc/id"
}

locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

################################################################################
### Security Groups
################################################################################

resource "aws_security_group" "set_alb_sg" {
  name        = "weather-app-alb-sg"
  description = "weather-app-alb-sg"
  vpc_id      = local.vpc_id

  ingress {
    description = "Internet Web Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "set_ecs_sg" {
  name        = "weather-app-ecs-sg"
  description = "weather-app-ecs-sg"
  vpc_id      = local.vpc_id

  ingress {
    description     = "ALB to ECS traffic"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.set_alb_sg.id]
  }
}

################################################################################
### Outputs
################################################################################

resource "aws_ssm_parameter" "sg_alb_id" {
  name  = "/${var.set_username_prefix}/${var.set_project_path}/sg/alb-id"
  type  = "String"
  value = aws_security_group.set_alb_sg.id
}

