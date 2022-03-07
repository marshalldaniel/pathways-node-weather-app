################################################################################
### Local variables
################################################################################
variable "set_username_prefix" {}
variable "set_project_path" {}
variable "private_subnet_1" {}
variable "private_subnet_2" {}
variable "alb_tg_arn" {}

# data "aws_ssm_parameter" "private_1_id" {
#   # name = "/${var.set_username_prefix}/${var.set_project_path}/vpc/id"
#   name = "/marshalldaniel/pathways/weather-app/az2"
# }

# data "aws_ssm_parameter" "private_2_id" {
#   # name = "/${var.set_username_prefix}/${var.set_project_path}/vpc/id"
#   name = "/marshalldaniel/pathways/weather-app/az2"
# }

data "aws_iam_role" "this" {
  # name = "${var.set_username_prefix}EcsExecutionRole"
  name = "marshalldanielEcsExecutionRole"
}

data "aws_ecr_repository" "this" {
  # name = "${var.set_username_prefix}-node-weather-app"
  name = "marshalldaniel-node-weather-app"
}

data "aws_security_group" "this" {
  name = "weather-app-ecs-sg"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}

data "aws_ssm_parameter" "vpc_id" {
  # name = "/${var.set_username_prefix}/${var.set_project_path}/vpc/id"
  name = "/marshalldaniel/pathways/weather-app/vpc/id"
}

################################################################################
### ECS
################################################################################
resource "aws_ecs_cluster" "this" {
  name = "marshalldaniel-weather-app-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "this" {
  family             = "marshalldaniel-weather-app-fam"
  network_mode       = "awsvpc"
  execution_role_arn = data.aws_iam_role.this.arn
  cpu                = 256
  memory             = 512
  container_definitions = jsonencode([
    {
      "portMappings" : [
        {
          "protocol" : "tcp",
          "containerPort" : 3000
        }
      ],
      "name" : "weather-app",
      "image" : "${data.aws_ecr_repository.this.repository_url}:1",
      "requiresCompatibilities" : [
        "FARGATE"
      ]
    }
  ])
}

# create ECS service (deploy weather-app container)
resource "aws_ecs_service" "this" {
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.this.arn
  name            = "marshalldaniel-weather-app-service"
  cluster         = aws_ecs_cluster.this.id
  desired_count   = 1

  load_balancer {
    target_group_arn = var.alb_tg_arn
    container_name   = "weather-app"
    container_port   = 3000
  }

  network_configuration {
    security_groups  = [data.aws_security_group.this.id]
    subnets          = [var.private_subnet_1, var.private_subnet_2]
    assign_public_ip = false
  }
}
