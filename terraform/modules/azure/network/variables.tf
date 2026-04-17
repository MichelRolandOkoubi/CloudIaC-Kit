variable "vnet_cidr" {
  description = "CIDR block for the VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_prefix" {
  description = "Public subnet address prefix"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_prefix" {
  description = "Private subnet address prefix"
  type        = string
  default     = "10.0.2.0/24"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
