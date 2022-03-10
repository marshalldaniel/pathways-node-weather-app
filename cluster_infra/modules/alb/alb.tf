################################################################################
### Local variables
################################################################################
variable "set_username_prefix" {}
variable "set_project_path" {}
variable "public_subnet_1" {}
variable "public_subnet_2" {}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.set_username_prefix}/${var.set_project_path}/vpc/id"
}

data "aws_security_group" "sg_alb_id" {
  name = "${var.set_username_prefix}-weather-app-alb-sg"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

################################################################################
### ALB
################################################################################
resource "aws_lb" "this" {
  name               = "${var.set_username_prefix}-weather-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.sg_alb_id.id]
  subnets            = [var.public_subnet_1, var.public_subnet_2]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "this" {
  name        = "${var.set_username_prefix}-weather-app-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_ssm_parameter.vpc_id.value
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

output "alb_url" {
  value = aws_lb.this.dns_name
}

output "alb_tg_arn" {
  value = aws_lb_target_group.this.arn
}
