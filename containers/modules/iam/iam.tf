################################################################################
# Define variables
################################################################################
variable "set_username_prefix" {}

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
### Define outputs
################################################################################

# output "s3_bucket_name" {
#   description = "The name of the bucket"
#   value       = aws_s3_bucket.this.id
# }
