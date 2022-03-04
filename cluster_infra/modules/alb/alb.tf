################################################################################
### Local variables
################################################################################
variable "set_username_prefix" {}
variable "set_project_path" {}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.set_username_prefix}/${var.set_project_path}/vpc/id"
}

data "aws_ssm_parameter" "sg_alb_id" {
  name = "/${var.set_username_prefix}/${var.set_project_path}/sg/alb-id"
}

locals {
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  sg_alb_id = data.aws_ssm_parameter.sg_alb_id
}





# resource "aws_ssm_parameter" "subnet_public_ids" {
#   name  = "/${var.set_username_prefix}/${var.set_project_path}/subnet/public/${count.index}/id"
#   type  = "String"
#   value = module.terraform_vpc.public_subnets[count.index]
# }


data "aws_ssm_parameters_by_path" "subnet_public_ids" {
  path = "/${var.set_username_prefix}/${var.set_project_path}/subnet/public"
  recursive = true
}



resource "random_shuffle" "random_subnets" {
  input        = [data.aws_ssm_parameters_by_path.subnet_public_ids.values]
  result_count = 2
}


################################################################################
### ALB
################################################################################

resource "aws_lb" "this" {
  name               = "weather-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.sg_alb_id]
  subnets            = ["${random_shuffle.random_subnets.result}"]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "this" {
  name        = "weather-app-tg"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = local.vpc_id
}

resource "aws_lb_target_group_attachment" "this" {
  target_group_arn = aws_lb_target_group.this.arn
  port             = 80
}


# resource "aws_lb_listener" "front_end" {
#   load_balancer_arn = aws_lb.this.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.this.arn
#   }
# }


