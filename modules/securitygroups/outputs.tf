output "alb_sg_id" {
  description = "Security Group ID for Application Load Balancer"
  value       = aws_security_group.alb_sg.id
}

output "app_sg_id" {
  description = "Security Group ID for Application tier"
  value       = aws_security_group.app_sg.id
}

output "db_sg_id" {
  description = "Security Group ID for Database tier"
  value       = aws_security_group.db_sg.id
}
