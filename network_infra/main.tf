################################################################################
### Reference the terraform_vpc module
################################################################################

module "terraform_vpc" {
  source                 = "terraform-aws-modules/vpc/aws"
  name                   = var.set_username_prefix
  cidr                   = var.set_vpc_cidr_range
  private_subnets        = var.create_private_subnets
  public_subnets         = var.create_public_subnets
  azs                    = var.get_azs
  create_igw             = var.create_igw
  enable_nat_gateway     = var.enable_nat_gateway
  one_nat_gateway_per_az = var.create_nat_gateway_per_az
  tags                   = var.set_custom_tags
}

################################################################################
### Reference the s3_bucket module
################################################################################

module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.bucket
  tags   = var.set_custom_tags
}

################################################################################
### VPC s3 gateway endpoint
################################################################################

data "aws_iam_policy_document" "set_gateway_endpoint_policy_document" {
  statement {
    sid = "AccessToSpecificBucket"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject"
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    resources = [
      "${module.s3_bucket.s3_bucket_name_arn}",
      "${module.s3_bucket.s3_bucket_name_arn}/*"
    ]
  }
}

resource "aws_vpc_endpoint" "s3" {
  service_name      = var.set_s3_gateway_endpoint
  vpc_id            = module.terraform_vpc.vpc_id
  policy            = data.aws_iam_policy_document.set_gateway_endpoint_policy_document.json
  vpc_endpoint_type = "Gateway"

  tags = var.set_custom_tags
}

resource "aws_vpc_endpoint_route_table_association" "private_associations" {
  count = length(module.terraform_vpc.private_route_table_ids)

  route_table_id  = module.terraform_vpc.private_route_table_ids[count.index]
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "public_associations" {
  count = length(module.terraform_vpc.public_route_table_ids)

  route_table_id  = module.terraform_vpc.public_route_table_ids[count.index]
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

################################################################################
### Outputs to SSM Parameter Store
################################################################################

# arn:partition:service:region:account-id:resource-id
# locals {
#   vpc_arn_list = split(":","${module.terraform_vpc.vpc_arn}")
# }

resource "aws_ssm_parameter" "region" {
  name  = "/${var.set_username_prefix}/${var.set_project_path}/region"
  type  = "String"
  value = element([split(":","${module.terraform_vpc.vpc_arn}")], 3)
}

resource "aws_ssm_parameter" "vpc_id_out" {
  name  = "/${var.set_username_prefix}/${var.set_project_path}/vpc/id"
  type  = "String"
  value = module.terraform_vpc.vpc_id
}

resource "aws_ssm_parameter" "subnet_public_ids" {
  count = length(module.terraform_vpc.public_subnets)

  name  = "/${var.set_username_prefix}/${var.set_project_path}/subnet/public/${count.index}/id"
  type  = "String"
  value = module.terraform_vpc.public_subnets[count.index]
}

resource "aws_ssm_parameter" "subnet_public_arns" {
  count = length(module.terraform_vpc.public_subnets)

  name  = "/${var.set_username_prefix}/${var.set_project_path}/subnet/public/${count.index}/arn"
  type  = "String"
  value = module.terraform_vpc.public_subnet_arns[count.index]
}

resource "aws_ssm_parameter" "subnet_private_ids" {
  count = length(module.terraform_vpc.private_subnets)

  name  = "/${var.set_username_prefix}/${var.set_project_path}/subnet/private/${count.index}/id"
  type  = "String"
  value = module.terraform_vpc.private_subnets[count.index]
}

resource "aws_ssm_parameter" "subnet_private_arns" {
  count = length(module.terraform_vpc.private_subnets)

  name  = "/${var.set_username_prefix}/${var.set_project_path}/subnet/private/${count.index}/arn"
  type  = "String"
  value = module.terraform_vpc.private_subnet_arns[count.index]
}
