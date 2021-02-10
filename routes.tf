resource "aws_main_route_table_association" "main_rtb" {
  vpc_id         = aws_vpc.default.id
  route_table_id = aws_route_table.private.id  
}
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }
  tags = {
    Name = "Public Route Table"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
 
  tags = {
    Name = "Private Route Table"
  }
}

resource "aws_route_table" "data" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "Data Route Table"
  }
}


