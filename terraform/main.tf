data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs                = slice(data.aws_availability_zones.available.names, 0, 2)
  assets_bucket_name = "${var.assets_bucket_prefix}-${var.student_id}"
}

# -------------------------
# Networking (VPC)
# -------------------------

resource "aws_vpc" "bedrock" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "project-bedrock-vpc"
    Project = "barakat-2025-capstone"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.bedrock.id

  tags = {
    Project = "barakat-2025-capstone"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.bedrock.id
  cidr_block              = cidrsubnet(aws_vpc.bedrock.cidr_block, 8, count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name    = "bedrock-public-${count.index}"
    Project = "barakat-2025-capstone"

    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.bedrock.id
  cidr_block        = cidrsubnet(aws_vpc.bedrock.cidr_block, 8, count.index + 10)
  availability_zone = local.azs[count.index]

  tags = {
    Name    = "bedrock-private-${count.index}"
    Project = "barakat-2025-capstone"

    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.bedrock.id

  tags = {
    Project = "barakat-2025-capstone"
  }
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Project = "barakat-2025-capstone"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Project = "barakat-2025-capstone"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.bedrock.id

  tags = {
    Project = "barakat-2025-capstone"
  }
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# -------------------------
# IAM for EKS
# -------------------------



