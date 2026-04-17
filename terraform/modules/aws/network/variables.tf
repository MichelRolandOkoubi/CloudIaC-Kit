# CIDR block for the VPC / Bloc CIDR pour le VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# List of public subnet CIDRs / Liste des CIDR pour les sous-réseaux publics
variable "public_subnets" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# List of private subnet CIDRs / Liste des CIDR pour les sous-réseaux privés
variable "private_subnets" {
  description = "List of private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

# Availability Zones to use / Zones de disponibilité à utiliser
variable "availability_zones" {
  description = "AZs to deploy subnets in"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# Environment Name (e.g. dev, prod) / Nom de l'environnement (ex: dev, prod)
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
