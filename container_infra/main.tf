################################################################################
### IAM
################################################################################

module "iam" {
  source              = "./modules/iam"
  set_username_prefix = var.set_username_prefix
}

################################################################################
### ECR Repository
################################################################################

module "ecr" {
  source              = "./modules/ecr"
  set_username_prefix = var.set_username_prefix
  set_project_path    = var.set_project_path
}

################################################################################
### Security Groups
################################################################################

module "sg" {
  source              = "./modules/sg"
  set_username_prefix = var.set_username_prefix
  set_project_path    = var.set_project_path
}

################################################################################
### ECS
################################################################################

# module "terraform_ecs" {
# # Has deprecated resource references - possibly look at manual creation for now.
#   source  = "terraform-aws-modules/ecs/aws"
#   version = "3.4.1"
#   # insert the 1 required variable here
#   name               = var.set_ecs_name
#   create_ecs         = var.set_create_ecs
#   container_insights = var.set_container_insights
#   tags               = var.set_custom_tags
# }

# module "ecs" {
#   source = "./modules/ecs"
#   set_username_prefix = var.set_username_prefix

# }

################################################################################
### Define outputs
################################################################################

