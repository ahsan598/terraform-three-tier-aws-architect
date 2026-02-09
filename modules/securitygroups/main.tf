# ============================================
# ALB SECURITY GROUP (Public-facing)
# ============================================
resource "aws_security_group" "alb_sg" {
  name_prefix = "${var.project_name}-alb-sg-"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  # Remove default allow-all egress
  egress = []

  lifecycle {
    create_before_destroy = true 
  }

  tags    = {
    Name  = "${var.project_name}-alb-sg"
  }
}

# =================================================
# ALB Ingress - Allow HTTP/HTTPS from Internet
# =================================================
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb_sg.id
  description       = "Allow HTTP inbound from internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  tags = {
    Name = "${var.project_name}-alb-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  count             = var.enable_https ? 1 : 0
  security_group_id = aws_security_group.alb_sg.id
  description       = "Allow HTTPS inbound from internet"

  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

  tags   = {
    Name = "${var.project_name}-alb-https"
  }
}

# =============================================
# ALB Egress - Allow traffic to App SG only
# =============================================
resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb_sg.id
  description                  = "Allow traffic to App tier"

  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.project_name}-alb-to-app"
  }
}

# =======================
# APP SECURITY GROUP
# =======================
resource "aws_security_group" "app_sg" {
  name_prefix = "${var.project_name}-app-sg-"
  description = "Security group for Application"
  vpc_id      = var.vpc_id

  egress = []

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

# =================================================
# APP Ingress - Allow traffic only from ALB
# =================================================
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app_sg.id
  description                  = "Allow app traffic from ALB only"

  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = var.app_port
  to_port                      = var.app_port
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.project_name}-app-from-alb"
  }
}

# ===================================================
# APP Egress - Allow HTTP traffic to internet
# (for package updates, API calls via NAT)
# ===================================================
resource "aws_vpc_security_group_egress_rule" "app_http" {
  security_group_id = aws_security_group.app_sg.id
  description       = "Allow HTTP traffic to internet for package updates"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"

  tags = {
    Name = "${var.project_name}-app-http"
  }
}

resource "aws_vpc_security_group_egress_rule" "app_https" {
  security_group_id = aws_security_group.app_sg.id
  description       = "Allow HTTPS traffic to internet"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
  ip_protocol = "tcp"

  tags = {
    Name = "${var.project_name}-app-https"
  }
}

# ===================================================
# APP Egress - Allow traffic to DB tier
# ===================================================
resource "aws_vpc_security_group_egress_rule" "app_to_db" {
  security_group_id            = aws_security_group.app_sg.id
  description                  = "Allow traffic to DB tier"

  referenced_security_group_id = aws_security_group.db_sg.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.project_name}-app-to-db"
  }
}

# =============================
# DATABASE SECURITY GROUP
# =============================
resource "aws_security_group" "db_sg" {
  name_prefix = "${var.project_name}-db-sg-"
  description = "Security group for DB tier"
  vpc_id      = var.vpc_id

  egress = []

  tags = {
    Name = "${var.project_name}-db-sg"
    Tier = "db"
  }
}

# =================================================
# DB Ingress - Allow MySQL only from App SG
# =================================================
resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db_sg.id
  description                  = "Allow MySQL from App SG"

  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"

  tags = {
    Name = "${var.project_name}-db-from-app"
  }
}

# ===================================================
# DB Egress - (Optional) Allow response to App SG
# ===================================================
resource "aws_vpc_security_group_egress_rule" "db_to_app" {
  security_group_id            = aws_security_group.db_sg.id
  description                  = "Allow response traffic to App SG"

  referenced_security_group_id = aws_security_group.app_sg.id
  from_port                    = 0
  to_port                      = 0
  ip_protocol                  = "-1"

  tags = {
    Name = "${var.project_name}-db-to-app"
  }
}
