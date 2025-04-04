resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyNetworkSegmentedVPC"
  }
}

#############################
# SUBNETS
#############################

# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.azs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-${var.azs[count.index]}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "Private-${var.azs[count.index]}"
  }
}

# Database (Isolated) Subnets
resource "aws_subnet" "db" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.db_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "DB-${var.azs[count.index]}"
  }
}

#############################
# INTERNET GATEWAY
#############################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MyIGW"
  }
}

#############################
# PUBLIC ROUTE TABLE & ASSOCIATIONS
#############################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RT"
  }
}

resource "aws_route_table_association" "public_association" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#############################
# NAT GATEWAYS FOR PRIVATE SUBNETS
#############################

# Create an Elastic IP for each NAT Gateway
resource "aws_eip" "nat" {
  count = length(var.azs)
  vpc   = true

  tags = {
    Name = "NAT-${var.azs[count.index]}"
  }
}

# Create NAT Gateway in each public subnet (one per AZ)
resource "aws_nat_gateway" "nat" {
  count         = length(var.azs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "NAT-Gateway-${var.azs[count.index]}"
  }
}

#############################
# PRIVATE ROUTE TABLES & ASSOCIATIONS
#############################

# Create a separate private route table per AZ that routes 0.0.0.0/0 via the NAT Gateway in the same AZ
resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name = "Private-RT-${var.azs[count.index]}"
  }
}

resource "aws_route_table_association" "private_association" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

#############################
# DATABASE ROUTE TABLES & ASSOCIATIONS
#############################

# Create isolated route tables for Database subnets (no route to IGW or NAT)
resource "aws_route_table" "db" {
  count  = length(var.azs)
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "DB-RT-${var.azs[count.index]}"
  }
}

resource "aws_route_table_association" "db_association" {
  count          = length(aws_subnet.db)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db[count.index].id
}
