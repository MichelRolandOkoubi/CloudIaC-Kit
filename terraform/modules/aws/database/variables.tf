# VPC ID / ID du VPC
variable "vpc_id" {
  type = string
}

# Private Subnet IDs / IDs des sous-réseaux privés
variable "private_subnet_ids" {
  type = list(string)
}

# DB Instance Class / Classe d'instance de base de données
variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

# Database Name / Nom de la base de données
variable "db_name" {
  type    = string
  default = "mydb"
}

# Master Username / Nom d'utilisateur principal
variable "db_username" {
  type    = string
  default = "admin"
}

# Master Password / Mot de passe principal
variable "db_password" {
  type      = string
  sensitive = true
}

# Environment Name / Nom de l'environnement
variable "environment" {
  type = string
}
