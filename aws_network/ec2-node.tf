resource "aws_instance" "k3s-node" {
  count = var.instance-count
  ami = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.example-a.id
  vpc_security_group_ids = [aws_security_group.example-allow-all.id]
  key_name = var.key_pair

  tags = {
    Name = "node-${count.index + 1}"
  }

  depends_on = [aws_instance.k3s-master]
}

/*
resource "null_resource" "k3s-node-provisioner" {
  count = 2
  depends_on = [aws_instance.k3s-node, null_resource.k3s-master-provisioner]
  triggers = {
    private_ip = aws_instance.k3s-node[count.index].private_ip
  }

  provisioner "remote-exec" {
    inline = [
        "sudo apt-get update && sudo apt-get install -y git ansible",
        "git clone https://github.com/shdkej/kubernetes-test",
        "ansible-playbook -c local -i 127.0.0.1, kubernetes-test/k3s-setup/node-playbook.yml",
    ]

    connection {
      host = aws_instance.k3s-node[count.index].private_ip
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/.ssh/aws-k3s")
    }
  }
}

resource "aws_eip" "k3s-node-eip" {
  count = 2
  instance = aws_instance.k3s-node[count.index].id
  vpc = true
}
*/

output "node-ip" {
  value = aws_instance.k3s-node.*.private_ip
}

resource "local_file" "private_ip" {
  content = join("\n", aws_instance.k3s-node.*.private_ip)
  filename = "k3s-setup/nodes"
}
