################################################################################
### Initial config variables
################################################################################

variable "set_username_prefix" {
  type        = string
  description = "Name to be used on all the resources as identifier"
  default     = null
}

variable "set_project_path" {
  type        = string
  description = "Project name to be used in path of SSM parameters to be exported"
  default     = null
}


################################################################################
### Obtain random subnets in same azs
################################################################################

data "aws_availability_zones" "az_all" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "random_shuffle" "az" {
  input        = ["${data.aws_availability_zones.az_all.names}"]
  result_count = 2
}

data "aws_subnet" "public_1" {
  filter {
    name   = "availability_zone"
    values = ["${resource.random_shuffle.az[0]}"]
  }
  filter {
    name   = "tag:Public_Route"
    values = ["true"]
  }
}

data "aws_subnet" "public_2" {
  filter {
    name   = "availability_zone"
    values = ["${resource.random_shuffle.az[1]}"]
  }
  filter {
    name   = "tag:Public_Route"
    values = ["true"]
  }
}

data "aws_subnet" "private_1" {
  filter {
    name   = "availability_zone"
    values = ["${resource.random_shuffle.az[0]}"]
  }
  filter {
    name   = "tag:Public_Route"
    values = ["false"]
  }
}

data "aws_subnet" "private_2" {
  filter {
    name   = "availability_zone"
    values = ["${resource.random_shuffle.az[1]}"]
  }
  filter {
    name   = "tag:Public_Route"
    values = ["false"]
  }
}



################################################################################
### Subnet vars
################################################################################

variable "set_public_1_id" {
  type        = string
  default     = data.aws_subnet.public_1.id
}
variable "set_public_2_id" {
  type        = string
  default     = data.aws_subnet.public_2.id
}
variable "set_private_1_id" {
  type        = string
  default     = data.aws_subnet.private_1.id
}
variable "set_private_2_id" {
  type        = string
  default     = data.aws_subnet.private_2.id
}
