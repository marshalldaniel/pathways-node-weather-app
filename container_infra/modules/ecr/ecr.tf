################################################################################
# Import ssm parameters to locals
################################################################################
variable "set_username_prefix" {}
variable "set_project_path" {}

################################################################################
### ECR
################################################################################

resource "aws_ecr_repository" "this" {
  name                 = "${var.set_username_prefix}-node-weather-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
