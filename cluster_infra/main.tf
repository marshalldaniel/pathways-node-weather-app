################################################################################
### ALB
################################################################################

module "alb" {
  source              = "./modules/alb"
  set_username_prefix = var.set_username_prefix
  set_project_path    = var.set_project_path
}

