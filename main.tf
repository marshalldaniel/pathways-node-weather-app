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
  source                  = "./modules/s3"
  bucket                  = var.bucket
  tags                    = var.set_custom_tags
}

################################################################################
### VPC s3 gateway endpoint
################################################################################

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.terraform-vpc.vpc_id
  service_name = var.set_s3_gateway_endpoint
}

################################################################################
### Additional public subnet route tables - 1 per AZ
################################################################################

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