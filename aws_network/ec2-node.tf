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

output "node-ip" {
  value = aws_instance.k3s-node.*.private_ip
}

resource "local_file" "private_ip" {
  content = join("\n", aws_instance.k3s-node.*.private_ip)
  filename = "k3s-setup/nodes"
}
