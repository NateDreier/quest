terraform {
  required_version = ">=0.14.0"
  #  backend "s3" {
  #    key    = "quest/global/terraform.state"
  #    bucket = "nates-terraform-state"
  #    region = "us-west-1"
  #
  #    dynamodb_table = "terraform-locks"
  #    encrypt        = true
  #  }
}

# Create container registry
resource "aws_ecr_repository" "ecr_quest" {
  provider = aws.region-east-primary
  name     = var.ecr_repository_name
  image_scanning_configuration {
    scan_on_push = true
  }
}

# Create network
module "vpc" {
  source = "./modules/vpc"

  subnet_east_1 = var.subnet_east_1
  subnet_east_2 = var.subnet_east_2
  external_ips  = var.external_ips
}

module "elb" {
  source = "./modules/elb"

  subnet_east_1_id    = module.vpc.subnet_east_1_id
  subnet_east_2_id    = module.vpc.subnet_east_2_id
  vpc_east_primary_id = module.vpc.vpc_east_primary_id
  dns-name            = var.dns-name
  external_ips        = var.external_ips
}