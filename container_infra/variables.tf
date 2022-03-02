################################################################################
### Tag variables
################################################################################

variable "set_username_prefix" {
  type        = string
  description = "Name to be used on all the resources as identifier"
  default     = "marshalldaniel"
}

variable "set_custom_tags" {
  type        = map(string)
  description = "Use tags to identify project resources"
  default = {
    Project_Name = "pathways-node-weather-app"
  }
}

################################################################################
### Inputs from SSM Parameter Store
################################################################################

data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.set_username_prefix}/pathways/weather-app/vpc/id"
}

data "aws_ssm_parameter" "subnet_private_id_0" {
  name = "/${var.set_username_prefix}/pathways/weather-app/subnet/private/0/id"
}

data "aws_ssm_parameter" "subnet_private_id_1" {
  name = "/${var.set_username_prefix}/pathways/weather-app/subnet/private/1/id"
}

data "aws_ssm_parameter" "subnet_private_id_2" {
  name = "/${var.set_username_prefix}/pathways/weather-app/subnet/private/2/id"
}

data "aws_ssm_parameter" "subnet_public_id_0" {
  name = "/${var.set_username_prefix}/pathways/weather-app/subnet/public/0/id"
}

data "aws_ssm_parameter" "subnet_public_id_1" {
  name = "/${var.set_username_prefix}/pathways/weather-app/subnet/public/1/id"
}

data "aws_ssm_parameter" "subnet_public_id_2" {
  name = "/${var.set_username_prefix}/pathways/weather-app/subnet/public/2/id"
}

# var.set_username_prefix = marshalldaniel

# call using
# something = data.aws_ssm_parameter.test.value

################################################################################
### SSM parameters to variables
################################################################################

variable "set_vpc_id" {
  type        = string
  description = "VPC ID obtained from SSM Parameter Store"
  default     = data.aws_ssm_parameter.vpc_id.value
}

variable "set_subnet_private_id_0" {
  type        = string
  description = "Private subnet 0 ID obtained from SSM Parameter Store"
  default     = data.aws_ssm_parameter.subnet_private_id_0.value
}

variable "set_subnet_private_id_1" {
  type        = string
  description = "Private subnet 1 ID obtained from SSM Parameter Store"
  default     = data.aws_ssm_parameter.subnet_private_id_1.value
}

variable "set_subnet_private_id_2" {
  type        = string
  description = "Private subnet 2 ID obtained from SSM Parameter Store"
  default     = data.aws_ssm_parameter.subnet_private_id_2.value
}

variable "set_subnet_public_id_0" {
  type        = string
  description = "Public subnet 0 ID obtained from SSM Parameter Store"
  default     = data.aws_ssm_parameter.subnet_public_id_0.value
}

variable "set_subnet_public_id_1" {
  type        = string
  description = "Public subnet 1 ID obtained from SSM Parameter Store"
  default     = data.aws_ssm_parameter.subnet_public_id_1.value
}

variable "set_subnet_public_id_2" {
  type        = string
  description = "Public subnet 2 ID obtained from SSM Parameter Store"
  default     = data.aws_ssm_parameter.subnet_public_id_2.value
}

################################################################################
### terraform_ecs module variables
################################################################################

# variable "set_ecs_name" {
#   type        = string
#   description = "Name to be used on all the resources as identifier, also the name of the ECS cluster"
#   default     = ""
# }

# variable "set_create_ecs" {
#   type        = bool
#   description = "Controls if ECS should be created"
#   default     = true
# }

# variable "set_container_insights" {
#   type        = bool
#   description = "Controls if ECS Cluster has container insights enabled"
#   default     = true
# }
