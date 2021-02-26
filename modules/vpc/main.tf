resource "aws_vpc" "vpc-east-primary" {
  provider             = aws.region-east-primary
  cidr_block           = var.vpc_east_subnet
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-east-1"
  }
}

resource "aws_internet_gateway" "igw-east-1" {
  provider = aws.region-east-primary
  vpc_id   = aws_vpc.vpc-east-primary.id
}

resource "aws_route_table" "internet-route-east" {
  provider = aws.region-east-primary
  vpc_id   = aws_vpc.vpc-east-primary.id
  route {
    cidr_block = var.external_ips
    gateway_id = aws_internet_gateway.igw-east-1.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "East-Primary-RT"
  }
}

resource "aws_main_route_table_association" "east-primary-rt-assoc" {
  provider       = aws.region-east-primary
  vpc_id         = aws_vpc.vpc-east-primary.id
  route_table_id = aws_route_table.internet-route-east.id
}

data "aws_availability_zones" "az-east-1" {
  provider = aws.region-east-primary
  state    = "available"
}

resource "aws_subnet" "subnet_east_1" {
  provider          = aws.region-east-primary
  vpc_id            = aws_vpc.vpc-east-primary.id
  availability_zone = element(data.aws_availability_zones.az-east-1.names, 0)
  cidr_block        = var.subnet_east_1
}

resource "aws_subnet" "subnet_east_2" {
  provider          = aws.region-east-primary
  vpc_id            = aws_vpc.vpc-east-primary.id
  availability_zone = element(data.aws_availability_zones.az-east-1.names, 1)
  cidr_block        = var.subnet_east_2
}