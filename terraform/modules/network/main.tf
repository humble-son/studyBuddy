resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = var.vpc_tag_name
  }
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id = aws_vpc.dev_vpc.id

  cidr_block = [
    "10.0.48.0/20",
    "10.0.64.0/20"
  ][count.index]

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = var.all_cidr
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

resource "aws_route_table_association" "public" {
  count = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private" {
  count = 2

  vpc_id            = aws_vpc.dev_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.dev_vpc.cidr_block, 4, count.index + 1)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

resource "aws_eip" "nat" {
 domain = var.aws_elastic_ip_vpc_domain
}

resource "aws_nat_gateway" "nat" {
  subnet_id = aws_subnet.public[1].id
  allocation_id = aws_eip.nat.id
  tags = {
    Name = var.aws_nat_gateway_tag
  }

  depends_on = [ aws_internet_gateway.igw ]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.dev_vpc.id

  route{
    cidr_block = var.all_cidr
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags={
    Name = var.private_route_table_name
  }
}

resource "aws_route_table_association" "private"{
  count = length(aws_subnet.private)
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}