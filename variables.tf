variable "region" {
  type        = string
  description = "Specifies the aws region to use"
  default     = "ap-southeast-1"
}

variable "bucket" {
  type        = string
  description = "Specifies the name of an S3 Bucket"
  default     = "marshalldaniel-pathways-s3-weather-app"
}

variable "tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default     = {}
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block to use for the VPC"
  default     = "10.0.5.0/24"
}

variable "subnet_private1_cidr" {
  type        = string
  description = "CIDR block to use for private subnet 1"
  default     = "10.0.5.0/26"
}

variable "subnet_private2_cidr" {
  type        = string
  description = "CIDR block to use for private subnet 2"
  default     = "10.0.5.64/26	"
}

variable "subnet_private3_cidr" {
  type        = string
  description = "CIDR block to use for private subnet 3"
  default     = "10.0.5.128/26"
}

variable "subnet_public1_cidr" {
  type        = string
  description = "CIDR block to use for public subnet 1"
  default     = "10.0.5.192/28"
}

variable "subnet_public2_cidr" {
  type        = string
  description = "CIDR block to use for public subnet 2"
  default     = "10.0.5.208/28"
}

variable "subnet_public3_cidr" {
  type        = string
  description = "CIDR block to use for public subnet 3"
  default     = "10.0.5.224/28"
}

# variable "subnet_public1_az" {
#   type        = string
#   description = "Availability zone to use for public subnet 1"
#   default     = ""
# }

# variable "subnet_public2_az" {
#   type        = string
#   description = "Availability zone to use for public subnet 2"
#   default     = ""
# }

# variable "subnet_public3_az" {
#   type        = string
#   description = "Availability zone to use for public subnet 3"
#   default     = ""
# }

# variable "subnet_private1_az" {
#   type        = string
#   description = "Availability zone to use for private subnet 1"
#   default     = ""
# }

# variable "subnet_private2_az" {
#   type        = string
#   description = "Availability zone to use for private subnet 2"
#   default     = ""
# }

# variable "subnet_private3_az" {
#   type        = string
#   description = "Availability zone to use for private subnet 3"
#   default     = "${local.region}c"
# }
