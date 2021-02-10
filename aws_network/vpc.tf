resource "aws_vpc" "example" {
  cidr_block = "172.10.0.0/20"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "example"
  }
}

resource "aws_subnet" "example-a" {
  vpc_id = aws_vpc.example.id
  cidr_block = "172.10.0.0/24"
  availability_zone = "eu-central-1b"
}

resource "aws_subnet" "example-b" {
  vpc_id = aws_vpc.example.id
  cidr_block = "172.10.1.0/24"
  availability_zone = "eu-central-1c"
}

resource "aws_route_table" "route-table-example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-env-gw.id
  }

  tags = {
    Name = "test-env-route-table"
  }
}

resource "aws_route_table_association" "subnet_association-a" {
  subnet_id = aws_subnet.example-a.id
  route_table_id = aws_route_table.route-table-example.id
}

resource "aws_route_table_association" "subnet_association-b" {
  subnet_id = aws_subnet.example-b.id
  route_table_id = aws_route_table.route-table-example.id
}
