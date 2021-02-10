resource "aws_internet_gateway" "test-env-gw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "example-gw"
  }
}
