output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
  description = "The public IP address of the bastion host"
}

output "ubuntu_private_ips" {
  value = aws_instance.ubuntu_ec2[*].private_ip
}

output "amazon_private_ips" {
  value = aws_instance.amazon_ec2[*].private_ip
}


# Output the public IP of the Ansible Controller
output "ansible_controller_public_ip" {
  value = aws_instance.ansible_controller.public_ip
  description = "Public IP of the Ansible controller node"
}



