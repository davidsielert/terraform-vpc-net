resource "aws_vpc" "default" {
  cidr_block = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  count = var.public_network_count
  cidr_block = cidrsubnet(var.vpc_cidr, var.network_bits,  count.index)
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "Public-${local.alphabet[count.index]}"
    Tier = "Public"
  }
}
resource "aws_subnet" "private" {
 count = var.private_network_count
  cidr_block = cidrsubnet(var.vpc_cidr, var.network_bits, count.index + var.public_network_count  )
  vpc_id = aws_vpc.default.id 
  availability_zone = "us-east-1${local.alphabet[count.index]}"
  tags = {
    Name = "Private-${local.alphabet[count.index]}"
    Tier = "Private"
  }
}

resource "aws_subnet" "data" {
  count = var.data_network_count
  cidr_block = cidrsubnet(var.vpc_cidr, var.network_bits, count.index + var.public_network_count + var.private_network_count)
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "Public-${local.alphabet[count.index]}"
    Tier = "Public"
  }
}

#Internet Gateway for Public/DMZ
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "Default Internet Gateway"
  }
}
#Elastic IP for NAT gateway
resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {
    Name = "NAT Gatway External EIP"
  }
}

#NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public[0].id
  tags = {
    Name = "NAT GW"
  }
}
resource "aws_route_table_association" "private" {
  route_table_id = aws_route_table.private.id
  subnet_id = aws_subnet.private[count.index].id
  count = var.private_network_count
}

resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.public.id
  subnet_id = aws_subnet.public[count.index].id
  count = var.public_network_count
}
resource "aws_route_table_association" "data" {
  route_table_id = aws_route_table.data.id
  subnet_id = aws_subnet.data[count.index].id
  count = var.data_network_count
}