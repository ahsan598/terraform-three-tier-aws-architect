# ============================================
# VPC Configuration Outputs
# ============================================
output "vpc_id" {
  description = "VPC ID"
  value       = module.aws_vpc.vpc_id
}

output "vpc_igw_id" {
  description = "VPC Internet Gateway ID"
  value       = module.aws_vpc.vpc_igw_id
}

output "public_subnet_alb_ids" {
  description = "List of public subnet IDs"
  value       = module.aws_vpc.public_subnet_alb_ids
}

output "private_subnet_app_ids" {
  description = "List of private subnet IDs for app"
  value       = module.aws_vpc.private_subnet_app_ids
}

output "private_subnet_db_ids" {
  description = "List of private subnet IDs for database"
  value       = module.aws_vpc.private_subnet_db_ids
}

output "nat_gateway_id" {
  description = "NAT Gateway ID"
  value       = module.aws_vpc.nat_gateway_id
}

# ============================================
# Security Groups Outputs
# ============================================
output "alb_sg_id" {
  description = "Security Group ID for Application Load Balancer"
  value       = module.aws_sg.alb_sg_id
}

output "app_sg_id" {
  description = "Security Group ID for Application/ECS tier"
  value       = module.aws_sg.app_sg_id
}

output "db_sg_id" {
  description = "Security Group ID for Database tier"
  value       = module.aws_sg.db_sg_id
}
