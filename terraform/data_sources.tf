data "aws_ami" "packer_ami" {
  most_recent = true
  owners      = ["self"]  

  filter {
    name   = "name"
    values = ["custom-amazon-linux-ami-*"]  # find ami created by  Packer 
  }
}
