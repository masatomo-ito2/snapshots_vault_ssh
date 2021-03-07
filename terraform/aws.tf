data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "ssh" {
  name        = var.env
  description = var.env
  vpc_id      = data.terraform_remote_state.aws_state.outputs.vpc_id_japan

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "vm" {
  instance_type               = "t2.nano"
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  subnet_id                   = data.terraform_remote_state.aws_state.outputs.public_subnets_japan[0]
  associate_public_ip_address = true
  user_data                   = data.template_file.init.rendered
  tags = {
    Name = "Snapshots VM client"
  }
}

data "template_file" "init" {
  template = file("${path.module}/scripts/setup.sh")

  vars = {
    tpl_env    = var.env
    tpl_region = var.region
  }
}