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
    resources = [
      "${module.s3_bucket.s3_bucket_name_arn}",
      "${module.s3_bucket.s3_bucket_name_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_gateway_endpoint_policy" {
  name        = "marshalldaniel_s3_gateway_endpoint_policy"
  path        = "/"
  description = "This policy restricts access to a specific S3 bucket on the S3 gateway endpoint"
  policy      = data.aws_iam_policy_document.set_gateway_endpoint_policy_document.json
}

resource "aws_vpc_endpoint" "s3" {
  service_name      = var.set_s3_gateway_endpoint
  vpc_id            = module.terraform_vpc.vpc_id
  policy            = data.aws_iam_policy_document.set_gateway_endpoint_policy_document.json
  vpc_endpoint_type = "Gateway"
  # route_table_ids = [
    # "asdf1", "asdf2", "asdf3"
    # "${join(",", "module.terraform_vpc.private_route_table_ids[*]")}"
    # priv_rt_id1, priv_rt_id2, priv_rt_id3
    # "${aws_route_table.public_rts[*].id}"
  # ]

  tags = var.set_custom_tags
  
  # depends_on = [
  #   aws_route_table.public_rts,
  # ]
}

resource "aws_vpc_endpoint_route_table_association" "private_associations" {
  count = length(module.terraform_vpc.private_route_table_ids)

  route_table_id  = module.terraform_vpc.private_route_table_ids[count.index]
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "public_associations" {
  count = length(aws_route_table.public_rts)

  route_table_id  = aws_route_table.public_rts[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}


# ################################################################################
# ### Additional public subnet route tables - 1 per AZ
# ################################################################################

resource "aws_route_table" "public_rts" {
  count = length(module.terraform_vpc.public_subnets)

  vpc_id = module.terraform_vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.terraform_vpc.igw_id
  }
  # depends_on = [
  #   module.terraform_vpc.public_subnets,
  # ]
}

resource "aws_route_table_association" "public_rt_associations" {
  count = length(aws_route_table.public_rts)

  subnet_id      = module.terraform_vpc.public_subnets[count.index]
  route_table_id = aws_route_table.public_rts[count.index].id
}
