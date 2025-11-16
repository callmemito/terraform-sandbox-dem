terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "terraform-state-sandbox-80kid"
    key            = "sandbox/network/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

# VPC
resource "aws_vpc" "test_network" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "test-network-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "test_network" {
  vpc_id = aws_vpc.test_network.id

  tags = {
    Name = "test-network-igw"
  }
}

# Public Subnet 1 (ap-northeast-1a)
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.test_network.id
  cidr_block              = "10.0.0.0/20"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "test-network-subnet-public1-ap-northeast-1a"
  }
}

# Public Subnet 2 (ap-northeast-1c)
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.test_network.id
  cidr_block              = "10.0.16.0/20"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "test-network-subnet-public2-ap-northeast-1c"
  }
}

# Private Subnet 1 (ap-northeast-1a)
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.test_network.id
  cidr_block        = "10.0.128.0/20"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "test-network-subnet-private1-ap-northeast-1a"
  }
}

# Private Subnet 2 (ap-northeast-1c)
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.test_network.id
  cidr_block        = "10.0.144.0/20"
  availability_zone = "ap-northeast-1c"

  tags = {
    Name = "test-network-subnet-private2-ap-northeast-1c"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.test_network.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_network.id
  }

  tags = {
    Name = "test-network-rtb-public"
  }
}

# Public Route Table Associations
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Private Route Table 1
resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.test_network.id

  tags = {
    Name = "test-network-rtb-private1-ap-northeast-1a"
  }
}

# Private Route Table 2
resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.test_network.id

  tags = {
    Name = "test-network-rtb-private2-ap-northeast-1c"
  }
}

# Private Route Table Associations
resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}

# VPC Endpoint for S3 (Gateway)
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.test_network.id
  service_name = "com.amazonaws.ap-northeast-1.s3"

  route_table_ids = [
    aws_route_table.private_1.id,
    aws_route_table.private_2.id
  ]

  tags = {
    Name = "test-network-vpce-s3"
  }
}

# Public Subnet 3 (ap-northeast-1d)
resource "aws_subnet" "public_3" {
  vpc_id                  = aws_vpc.test_network.id
  cidr_block              = "10.0.32.0/20"
  availability_zone       = "ap-northeast-1d"
  map_public_ip_on_launch = true

  tags = {
    Name = "test-network-subnet-public3-ap-northeast-1d"
  }
}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public.id
}
