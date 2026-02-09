# VPC module
module "aws_vpc" {
  source              = "./modules/networking"
  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnets_alb  = var.public_subnets_alb
  private_subnets_app = var.private_subnets_app
  private_subnets_db  = var.private_subnets_db
}

# Security Group module
module "aws_sg" {
  source       = "./modules/securitygroups"
  project_name = var.project_name
  vpc_id       = module.aws_vpc.vpc_id
  app_port     = var.app_port
  db_port      = var.db_port
  enable_https = var.enable_https
}