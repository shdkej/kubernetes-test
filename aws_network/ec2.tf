resource "aws_key_pair" "web_admin" {
  key_name = "web_admin"
  public_key = file("~/.ssh/aws-k3s.pub")
}

variable "key_pair" {
  default = "web_admin"
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
  owners = ["099720109477"]
}

resource "aws_instance" "k3s-master" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.example-a.id
  vpc_security_group_ids = [aws_security_group.example-allow-all.id]
  key_name = var.key_pair

  tags = {
    Name = "master"
  }
}

resource "null_resource" "k3s-master-provisioner" {
  depends_on = [aws_instance.k3s-master, aws_instance.k3s-node, aws_eip.k3s-master-eip, local_file.private_ip]

  triggers = {
    build_number = timestamp()
    public_ip = aws_instance.k3s-master.public_ip
  }

/*
  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.k3s-master.public_ip}, -u ubuntu --private-key ~/.ssh/aws-k3s k3s-setup/master-playbook.yml"
  }
*/

  provisioner "local-exec" {
    command = <<EOF
        yes | scp -i ~/.ssh/aws-k3s ~/.ssh/aws-k3s ubuntu@${aws_instance.k3s-master.public_ip}:/home/ubuntu/.ssh/aws-k3s
        yes | scp -i ~/.ssh/aws-k3s ./k3s-setup/nodes ubuntu@${aws_instance.k3s-master.public_ip}:/home/ubuntu/nodes
        EOF
  }

  provisioner "remote-exec" {
    inline = [
        "sudo apt-get update && sudo apt install -y git ansible",
        "rm -rf kubernetes-test",
        "git clone https://github.com/shdkej/kubernetes-test",
        "ansible-playbook -c local -i 127.0.0.1, kubernetes-test/k3s-setup/master-playbook.yml",
        "ansible-playbook -i ${aws_instance.k3s-node[0].private_ip}, kubernetes-test/k3s-setup/node-playbook.yml",
        "ansible-playbook -i ${aws_instance.k3s-node[1].private_ip}, kubernetes-test/k3s-setup/node-playbook.yml",
    ]

    connection {
      host = aws_instance.k3s-master.public_ip
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/.ssh/aws-k3s")
    }
  }
}

resource "aws_eip" "k3s-master-eip" {
  instance = aws_instance.k3s-master.id
  vpc = true
}

output "master-ip" {
  value = aws_instance.k3s-master.public_ip
}
