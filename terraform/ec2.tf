resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.packer_ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]  

  tags = {
    Name = "Bastion Host"
  }
}

resource "aws_instance" "private_instances" {
  count                  = 6
  ami                    = data.aws_ami.packer_ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]  

  tags = {
    Name = "Private-Instance-${count.index + 1}"
  }
}


