# DB Subnet Group: Groups your private subnets so the RDS instance knows which AZs it can span. / 
# Groupe de sous-réseaux : Groupe vos sous-réseaux privés pour que l'instance RDS sache dans quelles zones (AZ) elle peut s'étendre.
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name        = "${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

# DB Security Group: Specific rules to allow only the application layer to talk to the DB. / 
# Groupe de sécurité BD : Règles spécifiques pour permettre uniquement à la couche applicative de communiquer avec la base.
resource "aws_security_group" "db" {
  name        = "${var.environment}-db-sg"
  description = "Allow inbound PostgreSQL"
  vpc_id      = var.vpc_id

  # Inbound rule (PostgreSQL Port 5432) / Règle entrante (Port PostgreSQL 5432)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Restricted to internal VPC traffic / Restreint au trafic interne du VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS instance: The managed database service. It handles patching, backups, and scaling. / 
# Instance RDS : Service de base de données managé qui gère les correctifs, les sauvegardes et la mise à l'échelle.
resource "aws_db_instance" "main" {
  identifier           = "${var.environment}-db"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = var.db_instance_class
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]
  skip_final_snapshot  = true # Set to false in production for safety / Défini sur false en production pour la sécurité

  tags = {
    Name        = "${var.environment}-db"
    Environment = var.environment
  }
}
