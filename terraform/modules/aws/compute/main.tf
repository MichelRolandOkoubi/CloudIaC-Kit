# Data source to fetch the latest Ubuntu 20.04 AMI from Canonical. / 
# Source de données pour récupérer la dernière AMI Ubuntu 20.04 de Canonical (garantit une image à jour).
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Web Server Security Group: Acts as a virtual firewall for your EC2 instances. / 
# Groupe de sécurité Web : Agit comme un pare-feu virtuel pour vos instances EC2.
resource "aws_security_group" "web" {
  name        = "${var.environment}-web-sg"
  description = "Allow inbound HTTP and SSH"
  vpc_id      = var.vpc_id

  # SSH access (Port 22): Should be restricted to your IP in production. / Port 22 : Accès SSH (devrait être restreint en production).
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access (Port 80): Allows web traffic to reach your server. / Port 80 : Permet au trafic Web d'atteindre votre serveur.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound rules: Allows the server to talk to the internet (e.g. for updates). / Règles Sortantes : Permet au serveur de communiquer avec Internet.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Web Server Instances: Computes resources where your application will run. / 
# Instances de serveur Web : Ressources de calcul où votre application sera exécutée.
resource "aws_instance" "web" {
  count                  = length(var.public_subnet_ids)
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_ids[count.index]
  vpc_security_group_ids = [aws_security_group.web.id]

  # Using tags for identification and billing. / Utilisation de tags pour l'identification et la facturation.
  tags = {
    Name        = "${var.environment}-web-${count.index + 1}"
    Environment = var.environment
  }
}
