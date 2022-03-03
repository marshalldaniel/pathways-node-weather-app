### Network infra vars

################################################################################
### Tag variables
################################################################################

variable "set_username_prefix" {
  type        = string
  description = "Name to be used on all the resources as identifier"
  default     = ""
}

variable "set_custom_tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default = {
    Project_Name = "pathways-node-weather-app"
  }
}

variable "set_project_path" {
  type        = string
  description = "Project name to be used in path of SSM parameters to be exported"
  default     = ""
}

################################################################################
### terraform_vpc module variables
################################################################################

variable "set_vpc_cidr_range" {
  type        = string
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  default     = "10.0.5.0/24"
}

variable "create_private_subnets" {
  type        = list(string)
  description = "A list of private subnets inside the VPC"
  default     = ["10.0.5.0/26", "10.0.5.64/26", "10.0.5.128/26"]
}

variable "create_public_subnets" {
  type        = list(string)
  description = "A list of public subnets inside the VPC"
  default     = ["10.0.5.192/28", "10.0.5.208/28", "10.0.5.224/28"]
}

variable "get_azs" {
  type        = list(string)
  description = "A list of availability zones names or ids in the region"
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "create_igw" {
  type        = bool
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them"
  default     = true
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = true
}

variable "create_nat_gateway_per_az" {
  type        = bool
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`"
  default     = true
}

variable "set_s3_gateway_endpoint" {
  type        = string
  description = "Specifies the service name for the gateway endpoint"
  default     = "com.amazonaws.eu-west-1.s3"
}

################################################################################
### S3 module variables
################################################################################

variable "bucket" {
  type        = string
  description = "Specifies the name of an S3 Bucket"
  default     = "marshalldaniel-pathways-s3-weather-app"
}

################################################################################
### Variables to export to SSM parameters
################################################################################

resource "aws_ssm_parameter" "set_username_prefix" {
  name  = "/${var.set_username_prefix}/${var.set_project_path}/variables/set_username_prefix"
  type  = "String"
  value = var.set_username_prefix
}

resource "aws_ssm_parameter" "set_project_path" {
  name  = "/${var.set_username_prefix}/${var.set_project_path}/variables/set_project_path"
  type  = "String"
  value = var.set_project_path
}
