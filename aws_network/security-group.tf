resource "aws_security_group" "example-allow-all" {
  name = "example-allow_all"
  description = "Allow all inbound traffic"
  vpc_id = aws_vpc.example.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
