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

# locals {
#   endpoint_rt_ids = concat(["${module.terraform_vpc.private_route_table_ids}"], [for v in aws_route_table.public_rts : v.id])
  
#   depends_on = [
#     aws_route_table.public_rts,
#   ]
# }

data "aws_iam_policy_document" "set_gateway_endpoint_policy_document" {
  statement {
    sid = "AccessToSpecificBucket"
    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = [
      "${module.s3_bucket.s3_bucket_name_arn}",
      "${module.s3_bucket.s3_bucket_name_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_gateway_endpoint_policy" {
  name        = "s3_gateway_endpoint_policy"
  path        = "/"
  description = "This policy restricts access to a specific S3 bucket on the S3 gateway endpoint"
  policy      = data.aws_iam_policy_document.set_gateway_endpoint_policy_document.json
}

resource "aws_vpc_endpoint" "s3" {
  service_name      = var.set_s3_gateway_endpoint
  vpc_id            = module.terraform_vpc.vpc_id
  policy            = aws_iam_policy.s3_gateway_endpoint_policy.id
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    module.terraform_vpc.private_route_table_ids,
    aws_route_table.public_rts.id,
  ]

  tags = var.set_custom_tags
  
  depends_on = [
    aws_route_table.public_rts,
  ]
}

################################################################################
### Additional public subnet route tables - 1 per AZ
################################################################################

resource "aws_route_table" "public_rts" {
  count = length(module.terraform_vpc.public_subnets)

  vpc_id = module.terraform_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.terraform_vpc.igw_id
  }
  depends_on = [
    module.terraform_vpc.public_subnets,
  ]
}

# output "public_rt_ids" {
#   value = aws_route_table.public_rts.id
# }

locals {
  public_route_table_ids = [for v in aws_route_table.public_rts : v.id]
}

resource "aws_route_table_association" "public_rt_associations" {
  count = length(local.public_route_table_ids)

  subnet_id      = module.terraform_vpc.public_subnets.id[each.value]
  route_table_id = local.public_route_table_ids[each.value]
}
