# VPC Definition: The Virtual Private Cloud is your private isolated section of the cloud. / 
# Définition du VPC : Le VPC est votre section privée et isolée dans le cloud, servant de fondation au réseau.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true # Allows resources to have a public DNS name / Permet aux ressources d'avoir un nom DNS public
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

# Internet Gateway: This resource allows communication between your VPC and the internet. / 
# Passerelle Internet : Cette ressource permet la communication entre votre VPC et Internet (essentiel pour l'accès public).
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
  }
}

# Public Subnets: Used for resources that need to be reachable from the internet (e.g. Load Balancers). / 
# Sous-réseaux publics : Utilisés pour les ressources qui doivent être accessibles depuis Internet (ex : Load Balancers).
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true # Automatically assigns a public IP to instances / Attribue automatiquement une IP publique aux instances

  tags = {
    Name        = "${var.environment}-public-${count.index + 1}"
    Environment = var.environment
  }
}

# Private Subnets: Used for sensitive resources that should NOT be directly reachable from the internet (e.g. DBs). / 
# Sous-réseaux privés : Utilisés pour les ressources sensibles qui ne doivent PAS être accessibles directement depuis Internet (ex : Bases de données).
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name        = "${var.environment}-private-${count.index + 1}"
    Environment = var.environment
  }
}

# Route Table for Public Subnets: Defines where network traffic is directed. / 
# Table de routage pour les sous-réseaux publics : Définit vers où le trafic réseau est dirigé.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  # Default route to the Internet Gateway / Route par défaut vers la passerelle Internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
  }
}

# Subnet Association: Connects the public subnets to the public route table. / 
# Association de sous-réseau : Connecte les sous-réseaux publics à la table de routage publique.
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
