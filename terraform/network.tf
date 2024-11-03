
resource "aws_vpc" "gitlab_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "gitlab-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  for_each           = var.public_subnet_cidrs
  vpc_id             = aws_vpc.gitlab_vpc.id
  cidr_block         = each.value.cidr_block
  availability_zone  = each.value.az
  map_public_ip_on_launch = true  # Should be true for public subnets

  tags = {
    Name = "public-subnet-${each.key}"
  }
}

resource "aws_subnet" "private_subnets" {
  for_each           = var.private_subnet_cidrs
  vpc_id             = aws_vpc.gitlab_vpc.id
  cidr_block         = each.value.cidr_block
  availability_zone  = each.value.az
  map_public_ip_on_launch = false  # Should be false for private subnets

  tags = {
    Name = "private-subnet-${each.key}"
  }
}

resource "aws_internet_gateway" "gitlab_igw" {
  vpc_id = aws_vpc.gitlab_vpc.id

  tags = {
    Name = "gitlab-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.gitlab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gitlab_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.gitlab_vpc.id

  route {
    cidr_block = var.vpc_cidr  # Local route for the VPC
    gateway_id = "local"        # Use "local" to refer to the VPC local route
  }

  tags = {
    Name = "private-route-table"
  }
}


resource "aws_route_table_association" "public_association" {
  for_each = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_association" {
  for_each = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}