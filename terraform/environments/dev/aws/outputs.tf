output "web_instance_ips" {
  value = module.compute.instance_public_ips
}

output "db_endpoint" {
  value     = module.database.db_instance_address
  sensitive = true
}
