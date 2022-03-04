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
