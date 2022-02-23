# variable "region" {
#     default     = ""
# }
variable "vpc_cidr" {
    default     = ""
}
variable "subnet_public1_cidr" {
    default     = ""
}
variable "subnet_public2_cidr" {
    default     = ""
}
variable "subnet_public3_cidr" {
    default     = ""
}
variable "subnet_private1_cidr" {
    default     = ""
}
variable "subnet_private2_cidr" {
    default     = ""
}
variable "subnet_private3_cidr" {
    default     = ""
}
variable "subnet_public1_az" {
    default = "${var.region}a"
}
variable "subnet_public2_az" {
    default = "${var.region}b"
}
variable "subnet_public3_az" {
    default = "${var.region}c"
}
variable "subnet_private1_az" {
    default = "${var.region}a"
}
variable "subnet_private2_az" {
    default = "${var.region}b"
}
variable "subnet_private3_az" {
    default = "${var.region}c"
}


################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  cidr_block                       = var.vpc_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true

  tags = {
      Name = "marshalldaniel-vpc"
  }
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
      Name = "marshalldaniel-igw"
  }
}

################################################################################
# Publiс routes
################################################################################

resource "aws_route_table" "public1" {
  vpc_id = aws_vpc.this.id

  tags = {
      Name = "marshalldaniel-rt-public1"
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public1.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

################################################################################
# Private routes
################################################################################

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.this.id

  tags = {
      Name = "marshalldaniel-rt-private1"
  }
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.this.id

  tags = {
      Name = "marshalldaniel-rt-private2"
  }
}

resource "aws_route_table" "private3" {
  vpc_id = aws_vpc.this.id

  tags = {
      Name = "marshalldaniel-rt-private3"
  }
}

################################################################################
# Public subnets
################################################################################

resource "aws_subnet" "public1" {
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.subnet_public1_cidr
  availability_zone               = var.subnet_public1_az

  tags = {
      Name = "marshalldaniel-subnet-public1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.subnet_public2_cidr
  availability_zone               = var.subnet_public2_az

  tags = {
      Name = "marshalldaniel-subnet-public2"
  }
}

resource "aws_subnet" "public3" {
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.subnet_public3_cidr
  availability_zone               = var.subnet_public3_az

  tags = {
      Name = "marshalldaniel-subnet-public3"
  }
}

################################################################################
# Private subnets
################################################################################

resource "aws_subnet" "private1" {
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.subnet_private1_cidr
  availability_zone               = var.subnet_private1_az

  tags = {
      Name = "marshalldaniel-subnet-private1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.subnet_private2_cidr
  availability_zone               = var.subnet_private2_az

  tags = {
      Name = "marshalldaniel-subnet-private2"
  }
}

resource "aws_subnet" "private3" {
  vpc_id                          = aws_vpc.this.id
  cidr_block                      = var.subnet_private3_cidr
  availability_zone               = var.subnet_private3_az

  tags = {
      Name = "marshalldaniel-subnet-private3"
  }
}

################################################################################
# NAT Gateway
################################################################################

resource "aws_eip" "nat1" {
  vpc = true

  tags = {
      Name = "marshalldaniel-nat-eip1"
  }
}

resource "aws_eip" "nat2" {
  vpc = true

  tags = {
      Name = "marshalldaniel-nat-eip2"
  }
}

resource "aws_eip" "nat3" {
  vpc = true

  tags = {
      Name = "marshalldaniel-nat-eip3"
  }
}

resource "aws_nat_gateway" "nat-az1" {
  allocation_id = aws_eip.nat1.id
  subnet_id = aws_subnet.public1.id

  tags = {
      Name = "marshalldaniel-nat1"
  }
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "nat-az2" {
  allocation_id = aws_eip.nat2.id
  subnet_id = aws_subnet.public2.id

  tags = {
      Name = "marshalldaniel-nat2"
  }
  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "nat-az3" {
  allocation_id = aws_eip.nat3.id
  subnet_id = aws_subnet.public3.id

  tags = {
      Name = "marshalldaniel-nat3"
  }
  depends_on = [aws_internet_gateway.this]
}

resource "aws_route" "private_nat_gateway1" {
  route_table_id         = aws_route_table.private1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-az1.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway2" {
  route_table_id         = aws_route_table.private2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-az2.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route" "private_nat_gateway3" {
  route_table_id         = aws_route_table.private3.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-az3.id

  timeouts {
    create = "5m"
  }
}

################################################################################
# Route table association
################################################################################

resource "aws_route_table_association" "private1" {
  subnet_id = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}

resource "aws_route_table_association" "private3" {
  subnet_id = aws_subnet.private3.id
  route_table_id = aws_route_table.private3.id
}

resource "aws_route_table_association" "public1" {
  subnet_id = aws_subnet.public1.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route_table_association" "public2" {
  subnet_id = aws_subnet.public2.id
  route_table_id = aws_route_table.public1.id
}

resource "aws_route_table_association" "public3" {
  subnet_id = aws_subnet.public3.id
  route_table_id = aws_route_table.public1.id
}

################################################################################
# S3 Gateway Endpoint
################################################################################
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.this.id
  service_name = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [
    aws_route_table.public1.id,
    aws_route_table.private1.id,
    aws_route_table.private2.id,
    aws_route_table.private3.id
  ]

  tags = {
    Name = "marshalldaniel-s3-gatewayendpoint"
  }
  depends_on = [
    aws_route_table.public1,
    aws_route_table.private1,
    aws_route_table.private2,
    aws_route_table.private3
  ]
}
