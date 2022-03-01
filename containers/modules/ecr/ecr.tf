################################################################################
# Define variables
################################################################################
variable "set_username_prefix" {}

################################################################################
### ECR
################################################################################

# Visibility Settings: Private
# Repository name: {username}-node-weather-app  (replacing {username} )

resource "aws_ecr_repository" "this" {
  name                 = "${var.set_username_prefix}-node-weather-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

################################################################################
### Define outputs
################################################################################

# output "s3_bucket_name" {
#   description = "The name of the bucket"
#   value       = aws_s3_bucket.this.id
# }
