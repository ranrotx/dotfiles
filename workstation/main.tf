provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ipad-workstation" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "t3.small"
  key_name = "ronnie-ipad"
  subnet_id = "subnet-0e1cbda975e2b4ad4"
  vpc_security_group_ids = ["sg-018a1eb442ff4b774"]
  associate_public_ip_address = "true"
  iam_instance_profile = "ssm-instance"
  user_data = <<EOF
    #!/bin/bash
    set -e -x

    curl https://raw.githubusercontent.com/ranrotx/dotfiles/master/workstation/bootstrap.sh | \
      bash -s initialize | \
      tee /root/bootstrap.log

  EOF

  tags = {
    Name = "ipad-workstation"
    Workload = "devtools"
  }
}

output "public_ip" {
  value = "${aws_instance.ipad-workstation.public_ip}"
}
