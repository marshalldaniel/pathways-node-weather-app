################################################################################
### Reference the terraform-vpc module
################################################################################
module "terraform-vpc" {
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

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = module.terraform-vpc.vpc_id
#   service_name = var.set_s3_gateway_endpoint
# }

locals {
  # a = [ for v in aws_route_table.public_rts : v.id ]
  # endpoint_rt_ids = concat(["${module.terraform-vpc.private_route_table_ids}"], [ a ])
  # endpoint_rt_ids = concat(["${module.terraform-vpc.private_route_table_ids}"], [ public_route_table_ids ])
  endpoint_rt_ids = concat(["${module.terraform-vpc.private_route_table_ids}"], [for v in aws_route_table.public_rts : v.id])
}

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
  vpc_id            = module.terraform-vpc.vpc_id
  policy            = aws_iam_policy.s3_gateway_endpoint_policy.id
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    local.endpoint_rt_ids
  ]

  tags = var.set_custom_tags
}




# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = aws_vpc.this.id
#   service_name = "com.amazonaws.${var.region}.s3"
#   vpc_endpoint_type = "Gateway"
#   route_table_ids = [
#     aws_route_table.public1.id,
#     aws_route_table.private1.id,
#     aws_route_table.private2.id,
#     aws_route_table.private3.id
#   ]

#   tags = {
#     Name = "marshalldaniel-s3-gatewayendpoint"
#   }
#   depends_on = [
#     aws_route_table.public1,
#     aws_route_table.private1,
#     aws_route_table.private2,
#     aws_route_table.private3
#   ]
# }


################################################################################
### Additional public subnet route tables - 1 per AZ
################################################################################

# public_subnets
# Description: List of IDs of public subnets

# list of ids:
# module.terraform-vpc.public_subnets


# variable "subnet_ids" {
#   type = set(string)
# }

# locals {
#   subnet_ids = [for subnet in aws_subnet.subnets : subnet.id]
# }

# locals {
#   public_subnet_out = module.terraform-vpc.public_subnets
# }

resource "aws_route_table" "public_rts" {
  count = length(module.terraform-vpc.public_subnets)

  vpc_id = module.terraform-vpc.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.terraform-vpc.igw_id
  }
  depends_on = [
    module.terraform-vpc.public_subnets,
  ]
}

# Creates one RT for each public subnet

# output "public_route_table_out" {
#   value       = [ for v in aws_route_table.public_rts : v.id ]
#   description = "The route table ids."
# }

locals {
  public_route_table_ids = [for v in aws_route_table.public_rts : v.id]
}
# Tuple of RT 1, 2, 3


# locals {
#   subnet_route_pair = merge(
#     module.terraform-vpc.public_subnets,
#     aws_route_table.public_rts.id
#   )
#   type = "map"
# }

resource "aws_route_table_association" "public_rt_associations" {
  for_each = local.public_route_table_ids

  subnet_id      = module.terraform-vpc.public_subnets.id[each.value]
  route_table_id = local.public_route_table_ids[each.value]
}



# module.terraform-vpc.public_subnets


# resource "aws_route_table" "public1" {
#   vpc_id = aws_vpc.this.id

#   tags = {
#       Name = "marshalldaniel-rt-public1"
#   }
# }

# resource "aws_route" "public_internet_gateway" {
#   route_table_id         = aws_route_table.public1.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.this.id

#   timeouts {
#     create = "5m"
#   }
# }


# resource "aws_route_table_association" "public2" {
#   subnet_id = aws_subnet.public2.id
#   route_table_id = aws_route_table.public1.id
# }

# resource "aws_route_table_association" "public3" {
#   subnet_id = aws_subnet.public3.id
#   route_table_id = aws_route_table.public1.id
# }
