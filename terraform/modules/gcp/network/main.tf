# VPC Network / Réseau VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.environment}-${var.vpc_name}"
  auto_create_subnetworks = false
}

# Subnetwork / Sous-réseau
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.environment}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Firewall Rules (SSH & HTTP) / Règles de pare-feu (SSH et HTTP)
resource "google_compute_firewall" "allow_ssh_http" {
  name    = "${var.environment}-allow-ssh-http"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
}
