variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "environment" {
  type = string
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}
