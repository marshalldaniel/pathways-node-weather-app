################################################################################
### Obtain all AZs in region and randomly select two
################################################################################
data "aws_availability_zones" "az_all" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "random_shuffle" "az" {
  input        = data.aws_availability_zones.az_all.names
  result_count = 2
}

################################################################################
### Obtain private and public subnets in same AZs
################################################################################
data "aws_subnet" "public_1" {
  filter {
    name   = "availability-zone"
    values = [resource.random_shuffle.az.result[0]]
  }
  filter {
    name   = "tag:Public_Route"
    values = ["true"]
  }
}

data "aws_subnet" "public_2" {
  filter {
    name   = "availability-zone"
    values = [resource.random_shuffle.az.result[1]]
  }
  filter {
    name   = "tag:Public_Route"
    values = ["true"]
  }
}

data "aws_subnet" "private_1" {
  filter {
    name   = "availability-zone"
    values = [resource.random_shuffle.az.result[0]]
  }
  filter {
    name   = "tag:Public_Route"
    values = ["false"]
  }
}

data "aws_subnet" "private_2" {
  filter {
    name   = "availability-zone"
    values = [resource.random_shuffle.az.result[1]]
  }
  filter {
    name   = "tag:Public_Route"
    values = ["false"]
  }
}

output "public_subnet_id1" {
  value = data.aws_subnet.public_1.id
}

output "public_subnet_id2" {
  value = data.aws_subnet.public_2.id
}

output "private_subnet_id1" {
  value = data.aws_subnet.private_1.id
}

output "private_subnet_id2" {
  value = data.aws_subnet.private_2.id
}

################################################################################
### ALB
################################################################################
module "alb" {
  source              = "./modules/alb"
  set_username_prefix = var.set_username_prefix
  set_project_path    = var.set_project_path
  public_subnet_1     = data.aws_subnet.public_1.id
  public_subnet_2     = data.aws_subnet.public_2.id
}

output "alb_url" {
  value = module.alb.alb_url
}

################################################################################
### ECS
################################################################################
module "ecs" {
  source              = "./modules/ecs"
  set_username_prefix = var.set_username_prefix
  set_project_path    = var.set_project_path
  private_subnet_1    = data.aws_subnet.private_1.id
  private_subnet_2    = data.aws_subnet.private_2.id
  alb_tg_arn          = module.alb.alb_tg_arn
}
