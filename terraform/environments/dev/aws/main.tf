# Terraform Configuration / Configuration Terraform
terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  # Uncomment to use S3 for remote state / Décommenter pour utiliser S3 pour l'état distant
  # backend "s3" {
  #   bucket = "my-terraform-state"
  #   key    = "aws/dev/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

# Provider Initialization / Initialisation du fournisseur
provider "aws" {
  region = var.aws_region
}

# Network Layer / Couche Réseau
module "network" {
  source      = "../../../modules/aws/network"
  environment = "dev"
}

# Compute Layer (Web Servers) / Couche Calcul (Serveurs Web)
module "compute" {
  source            = "../../../modules/aws/compute"
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  environment       = "dev"
}

# Database Layer / Couche Base de données
module "database" {
  source             = "../../../modules/aws/database"
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  db_password        = var.db_password
  environment        = "dev"
}
