packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

# 声明变量
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

# 使用 locals 定义 timestamp 变量
locals {
  ami_name = "custom-amazon-linux-ami-${replace(timestamp(), ":", "-")}"
}

# 定义 Amazon EBS 构建源
source "amazon-ebs" "example" {
  region        = var.aws_region
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"
  ami_name      = local.ami_name
  ami_description = "Amazon Linux AMI with Docker installed"

  # source_ami_filter 自动获取最新的 Amazon Linux 2 AMI
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["137112412989"]  # Amazon 官方账户 ID
    most_recent = true
  }

  # 添加 SSH 密钥
  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 10
  }

  terminate_instance = false
}

# 定义 build 过程
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
