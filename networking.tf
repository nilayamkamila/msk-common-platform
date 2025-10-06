locals {
  common_tags = merge({ Project = var.project }, var.tags)
}

# ----- PRIMARY Region VPC & networking -----
resource "aws_vpc" "primary" {
  provider = aws.primary
  cidr_block = var.vpc_cidr_primary
  tags = merge(local.common_tags, { Name = "${var.project}-vpc-${var.aws_region_primary}" })
}

# Internet gateway
resource "aws_internet_gateway" "primary" {
  provider = aws.primary
  vpc_id = aws_vpc.primary.id
  tags   = merge(local.common_tags, { Name = "${var.project}-igw-${var.aws_region_primary}" })
}

# Public subnets
resource "aws_subnet" "primary_public" {
  provider = aws.primary
  count    = length(var.public_subnet_cidrs_primary)
  vpc_id   = aws_vpc.primary.id
  cidr_block = var.public_subnet_cidrs_primary[count.index]
  availability_zone = length(var.availability_zones_primary) > 0 ? var.availability_zones_primary[count.index] : null
  map_public_ip_on_launch = true
  tags = merge(local.common_tags, { Name = "${var.project}-public-${count.index}-${var.aws_region_primary}" })
}

# Private subnets (for MSK client subnets)
resource "aws_subnet" "primary_private" {
  provider = aws.primary
  count    = length(var.private_subnet_cidrs_primary)
  vpc_id   = aws_vpc.primary.id
  cidr_block = var.private_subnet_cidrs_primary[count.index]
  availability_zone = length(var.availability_zones_primary) > 0 ? var.availability_zones_primary[count.index] : null
  map_public_ip_on_launch = false
  tags = merge(local.common_tags, { Name = "${var.project}-private-${count.index}-${var.aws_region_primary}" })
}

# Route Table + Association for public subnets
resource "aws_route_table" "primary_public" {
  provider = aws.primary
  vpc_id = aws_vpc.primary.id
  tags = merge(local.common_tags, { Name = "${var.project}-rt-public-${var.aws_region_primary}" })
}

resource "aws_route" "primary_public_igw" {
  provider = aws.primary
  route_table_id = aws_route_table.primary_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.primary.id
}

resource "aws_route_table_association" "primary_public_assoc" {
  provider = aws.primary
  count = length(aws_subnet.primary_public)
  subnet_id = aws_subnet.primary_public[count.index].id
  route_table_id = aws_route_table.primary_public.id
}

# NACL
resource "aws_network_acl" "primary" {
  provider = aws.primary
  vpc_id = aws_vpc.primary.id
  tags = merge(local.common_tags, { Name = "${var.project}-nacl-${var.aws_region_primary}" })
}

# NACL Rules: allow ephemeral + kafka ports + HTTP for health (optional)
resource "aws_network_acl_rule" "primary_allow_kafka_in" {
  provider = aws.primary
  network_acl_id = aws_network_acl.primary.id
  rule_number = 100
  egress = false
  protocol = "6" # TCP
  rule_action = "allow"
  cidr_block = local.local_ip_cidr
  from_port = 9092
  to_port = 9094
}

resource "aws_network_acl_rule" "primary_allow_ephemeral" {
  provider = aws.primary
  network_acl_id = aws_network_acl.primary.id
  rule_number = 110
  egress = false
  protocol = "6"
  rule_action = "allow"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_association" "primary_public_assoc" {
  provider = aws.primary
  count = length(aws_subnet.primary_public)
  subnet_id = aws_subnet.primary_public[count.index].id
  network_acl_id = aws_network_acl.primary.id
}
