packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}


variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "ssh_key_name" {
  type    = string
  default = "bookshop-key"
}

variable "ssh_public_key" {
  type    = string
  default = "/Users/daikexin/.ssh/id_rsa.pub"
}


locals {
  ami_name = "custom-amazon-linux-ami-${replace(timestamp(), ":", "-")}"
}


source "amazon-ebs" "example" {
  region        = var.aws_region
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = local.ami_name
  ami_description = "Amazon Linux AMI with Docker installed"


  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["137112412989"] 
    most_recent = true
  }


  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 10
  }

  # terminate_instance = false
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras enable docker",
      "sudo yum install -y docker",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo usermod -aG docker ec2-user"
    ]
  }

  provisioner "file" {
    source      = var.ssh_public_key
    destination = "/home/ec2-user/.ssh/authorized_keys"
  }
}
