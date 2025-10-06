# PRIMARY SG
resource "aws_security_group" "primary_msk" {
  provider = aws.primary
  name        = "${var.project}-msk-sg-${var.aws_region_primary}"
  description = "MSK SG - allow Kafka ports from local laptop and intra-SG"
  vpc_id      = aws_vpc.primary.id
  tags = merge(local.common_tags, { Name = "${var.project}-msk-sg-${var.aws_region_primary}" })
}

# Allow inbound Kafka from your laptop (public IP)
resource "aws_security_group_rule" "primary_allow_local_kafka" {
  provider = aws.primary
  type = "ingress"
  from_port = 9092
  to_port   = 9094
  protocol  = "tcp"
  cidr_blocks = [local.local_ip_cidr]
  security_group_id = aws_security_group.primary_msk.id
  description = "Allow Kafka client access from local laptop"
}

# Allow brokers talk to each other (intra SG)
resource "aws_security_group_rule" "primary_intra_sg" {
  provider = aws.primary
  type = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  security_group_id = aws_security_group.primary_msk.id
  source_security_group_id = aws_security_group.primary_msk.id
  description = "Intra SG communication for broker replication"
}

# EGRESS open (default) - allow all outbound
resource "aws_security_group_rule" "primary_allow_all_egress" {
  provider = aws.primary
  type = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.primary_msk.id
  description = "Allow all outbound"
}

# ----- SECONDARY REGION -----
resource "aws_vpc" "secondary" {
  provider = aws.secondary
  cidr_block = var.vpc_cidr_secondary
  tags = merge(local.common_tags, { Name = "${var.project}-vpc-${var.aws_region_secondary}" })
}

# Internet gateway in secondary
resource "aws_internet_gateway" "secondary" {
  provider = aws.secondary
  vpc_id = aws_vpc.secondary.id
  tags = merge(local.common_tags, { Name = "${var.project}-igw-${var.aws_region_secondary}" })
}

# Subnets in secondary
resource "aws_subnet" "secondary_public" {
  provider = aws.secondary
  count    = length(var.public_subnet_cidrs_secondary)
  vpc_id   = aws_vpc.secondary.id
  cidr_block = var.public_subnet_cidrs_secondary[count.index]
  map_public_ip_on_launch = true
  availability_zone = length(var.availability_zones_secondary) > 0 ? var.availability_zones_secondary[count.index] : null
  tags = merge(local.common_tags, { Name = "${var.project}-public-${count.index}-${var.aws_region_secondary}" })
}

resource "aws_subnet" "secondary_private" {
  provider = aws.secondary
  count    = length(var.private_subnet_cidrs_secondary)
  vpc_id   = aws_vpc.secondary.id
  cidr_block = var.private_subnet_cidrs_secondary[count.index]
  map_public_ip_on_launch = false
  availability_zone = length(var.availability_zones_secondary) > 0 ? var.availability_zones_secondary[count.index] : null
  tags = merge(local.common_tags, { Name = "${var.project}-private-${count.index}-${var.aws_region_secondary}" })
}

resource "aws_security_group" "secondary_msk" {
  provider = aws.secondary
  name        = "${var.project}-msk-sg-${var.aws_region_secondary}"
  description = "MSK SG - allow Kafka ports from local laptop and intra-SG"
  vpc_id      = aws_vpc.secondary.id
  tags = merge(local.common_tags, { Name = "${var.project}-msk-sg-${var.aws_region_secondary}" })
}

resource "aws_security_group_rule" "secondary_allow_local_kafka" {
  provider = aws.secondary
  type = "ingress"
  from_port = 9092
  to_port   = 9094
  protocol  = "tcp"
  cidr_blocks = [local.local_ip_cidr]
  security_group_id = aws_security_group.secondary_msk.id
  description = "Allow Kafka client access from local laptop"
}

resource "aws_security_group_rule" "secondary_intra_sg" {
  provider = aws.secondary
  type = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  security_group_id = aws_security_group.secondary_msk.id
  source_security_group_id = aws_security_group.secondary_msk.id
  description = "Intra SG communication for broker replication"
}

resource "aws_security_group_rule" "secondary_allow_all_egress" {
  provider = aws.secondary
  type = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.secondary_msk.id
  description = "Allow all outbound"
}
