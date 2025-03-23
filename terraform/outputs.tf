output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
  description = "The public IP address of the bastion host"
}

output "private_instance_ips" {
  value = aws_instance.private_instances[*].private_ip
  description = "The private IP addresses of the private instances"
}

