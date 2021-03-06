provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "Main-Vpc"
  }
}

resource "aws_subnet" "public_subnet_1" {
  cidr_block        = var.public_subnet_1_cidr
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "Public-subnet-1"
  }
}

resource "aws_subnet" "public_subnet_2" {
  cidr_block        = var.public_subnet_2_cidr
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name = "Public-subnet-2"
  }
}

resource "aws_subnet" "public_subnet_3" {
  cidr_block        = var.public_subnet_3_cidr
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "Public-subnet-3"
  }
}

resource "aws_subnet" "private_subnet_1" {
  cidr_block        = var.private_subnet_1_cidr
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = "${var.region}a"

  tags = {
    Name = "Private-subnet-1"
  }
}


resource "aws_subnet" "private_subnet_2" {
  cidr_block        = var.private_subnet_2_cidr
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = "${var.region}b"

  tags = {
    Name = "Private-subnet-2"
  }
}

resource "aws_subnet" "private_subnet_3" {
  cidr_block        = var.private_subnet_3_cidr
  vpc_id            = aws_vpc.main_vpc.id
  availability_zone = "${var.region}c"

  tags = {
    Name = "Private-subnet-3"
  }
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Public route table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Private route table"
  }
}

resource "aws_route_table_association" "public_route_table_1_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_1.id
}

resource "aws_route_table_association" "public_route_table_2_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_2.id
}

resource "aws_route_table_association" "public_route_table_3_association" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet_3.id
}

resource "aws_route_table_association" "private_route_table_1_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet_1.id
}

resource "aws_route_table_association" "private_route_table_2_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet_2.id
}

resource "aws_route_table_association" "private_route_table_3_association" {
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = aws_subnet.private_subnet_3.id
}

resource "aws_eip" "elastic_ip_for_nat_gw" {
  vpc                       = true
  associate_with_private_ip = "10.0.0.5"

  tags = {
    Name = "Main-EIP"
  }
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.elastic_ip_for_nat_gw.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "Main-Nat-Gw"
  }
}

resource "aws_route" "nat-gw-route" {
  route_table_id         = aws_route_table.private_route_table.id
  nat_gateway_id         = aws_nat_gateway.nat-gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Main-Igw"
  }
}

resource "aws_route" "public_internet_gw_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.main_igw.id
  destination_cidr_block = "0.0.0.0/0"
}
