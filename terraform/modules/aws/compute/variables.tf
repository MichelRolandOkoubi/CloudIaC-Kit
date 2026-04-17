# VPC ID / ID du VPC
variable "vpc_id" {
  type = string
}

# Public Subnet IDs / IDs des sous-réseaux publics
variable "public_subnet_ids" {
  type = list(string)
}

# Instance Type / Type d'instance
variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# Environment Name / Nom de l'environnement
variable "environment" {
  type = string
}
