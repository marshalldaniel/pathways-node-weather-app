module "s3_bucket" {
  source = "./modules/s3"
  bucket = var.bucket

  tags = var.tags
}

module "vpc" {
  source = "./modules/vpc"
}

output "bucket_name" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name}"]
}

output "bucket_name_arn" {
  description = "The name of the bucket"
  value       = ["${module.s3_bucket.s3_bucket_name_arn}"]
}