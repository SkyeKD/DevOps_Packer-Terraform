resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.packer_ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]  

  tags = {
    Name = "Bastion Host"
  }
}


# --------------------
# 3 Ubuntu EC2 Instances
# --------------------
resource "aws_instance" "ubuntu_ec2" {
  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  # Round-robin distribute across private subnets
  subnet_id     =  aws_subnet.private.id

  key_name      = "bookshop-key"

  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "ubuntu-${count.index}"
    OS   = "ubuntu"
  }
}

# --------------------
# 3 Amazon Linux EC2 Instances
# --------------------
resource "aws_instance" "amazon_ec2" {
  count         = 3
  ami           = data.aws_ami.packer_ami.id  # This should refer to your Packer-built Amazon Linux AMI
  instance_type = "t2.micro"

  subnet_id     =  aws_subnet.private.id

  key_name      = "bookshop-key"

  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "amazon-${count.index}"
    OS   = "amazon"
  }
}

# --------------------
# 1 Ansible Controller EC2 Instance
# --------------------
resource "aws_instance" "ansible_controller" {
  ami                    = data.aws_ami.packer_ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  associate_public_ip_address = true

  key_name               = "bookshop-key"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]  

  tags = {
    Name = "ansible-controller"
    Role = "controller"
  }
}


