output "instance_public_ips" {
  value = aws_instance.web[*].public_ip
}

output "security_group_id" {
  value = aws_security_group.web.id
}
