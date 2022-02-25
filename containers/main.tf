################################################################################
### IAM
################################################################################

# Create iam policy for ecs
resource "aws_iam_policy" "ecs_policy" {
  name        = "${var.set_username_prefix}EcsEcrAccess"
  path        = "/"
  description = "ECS exection policy (allows ECS to pull images from ECR)"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Create iam role for ecs
resource "aws_iam_role" "ecs_role" {
  name = "${var.set_username_prefix}EcsExecutionRole"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : [
            "ecs-tasks.amazonaws.com"
          ]
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "ecs_attach_policy" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = aws_iam_policy.ecs_policy.arn
}

################################################################################
### ECR Repository
################################################################################

# Visibility Settings: Private
# Repository name: {username}-node-weather-app  (replacing {username} )

resource "aws_ecr_repository" "foo" {
  name                 = "${var.set_username_prefix}-node-weather-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

################################################################################
### ECS
################################################################################

module "terraform_ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "3.4.1"
  # insert the 1 required variable here
  name               = var.set_ecs_name
  create_ecs         = var.set_create_ecs
  container_insights = var.set_container_insights
  tags               = var.set_custom_tags
}

