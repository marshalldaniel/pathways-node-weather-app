################################################################################
### Locals
################################################################################

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.set_username_prefix}/${var.set_project_path}/vpc/id"
}

locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}


################################################################################
### ALB
################################################################################



resource "aws_lb_target_group" "this" {
  name        = "weather-app-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = local.vpc_id
}



resource "aws_lb" "this" {
  name               = "weather-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]

  enable_deletion_protection = false

}


resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.test.id
  port             = 80
}

