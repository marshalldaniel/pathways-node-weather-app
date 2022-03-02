################################################################################
# Define variables
################################################################################
variable "set_username_prefix" {}



################################################################################
### IAM
################################################################################

data "aws_iam_policy_document" "set_ecs_iam_document" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken"
    ]
    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "set_ecs_trust_document" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Create iam policy for ecs
resource "aws_iam_policy" "set_ecs_iam_policy" {
  name        = "${var.set_username_prefix}EcsEcrAccess"
  path        = "/"
  description = "ECS exection policy (allows ECS to pull images from ECR)"
  policy = data.aws_iam_policy_document.set_ecs_iam_document.json
}

# Create iam role for ecs
resource "aws_iam_role" "set_ecs_iam_role" {
  name = "${var.set_username_prefix}EcsExecutionRole"

  assume_role_policy = data.aws_iam_policy_document.set_ecs_trust_document.json
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "ecs_attach_policy" {
  role       = aws_iam_role.set_ecs_iam_role.name
  policy_arn = aws_iam_policy.set_ecs_iam_policy.arn
}

################################################################################
### Define outputs
################################################################################

# output "s3_bucket_name" {
#   description = "The name of the bucket"
#   value       = aws_s3_bucket.this.id
# }
