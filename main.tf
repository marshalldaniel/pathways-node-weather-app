module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.bucket

  tags = var.tags
}

# module "vpc" {
#   source                   = "terraform-aws-modules/vpc/aws"
#   name                     = var.project_name
#   cidr                     = var.vpc_cidr
#   instance_tenancy         = var.vpc_tenancy
#   enable_dns_hostnames     = var.enable_dns_hostnames
#   azs                      = var.azs
#   private_subnet_suffix    = var.private_subnet_suffix
#   private_subnets          = var.private_subnets
#   private_route_table_tags = var.private_route_table_tags
#   public_subnet_suffix     = var.public_subnet_suffix
#   public_subnets           = var.public_subnets
#   public_route_table_tags  = var.public_route_table_tags
#   create_igw               = true
#   enable_nat_gateway       = true
#   one_nat_gateway_per_az   = true

#   tags = {
#     Author = "Vishaal Pal"
#   }
# }

output "bucket_name" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name}"]
}

output "bucket_name_arn" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name_arn}"]
}