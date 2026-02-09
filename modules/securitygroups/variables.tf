variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "app_port" {
  description = "Port on which the application listens"
  type        = number
}

variable "db_port" {
  description = "Port on which the database listens"
  type        = number
}

variable "enable_https" {
  description = "Enable HTTPS ingress rule for ALB"
  type        = bool
}
