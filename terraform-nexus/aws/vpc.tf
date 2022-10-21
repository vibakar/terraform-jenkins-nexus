resource "aws_vpc" "nexus" {
  cidr_block           = var.VPC_CIDR_BLOCK
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { for k, v in var.TAGS : k => lower(v) }
}

resource "aws_subnet" "nexus" {
  vpc_id                  = aws_vpc.nexus.id
  cidr_block              = var.SUBNET_CIDR_BLOCK
  availability_zone       = var.SUBNET_AVAILABILITY_ZONE
  map_public_ip_on_launch = true

  tags = { for k, v in var.TAGS : k => lower(v) }
}

resource "aws_internet_gateway" "nexus" {
  vpc_id = aws_vpc.nexus.id

  tags = { for k, v in var.TAGS : k => lower(v) }
}

resource "aws_route_table" "nexus" {
  vpc_id = aws_vpc.nexus.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nexus.id
  }

  tags = { for k, v in var.TAGS : k => lower(v) }
}

resource "aws_route_table_association" "nexus" {
  subnet_id      = aws_subnet.nexus.id
  route_table_id = aws_route_table.nexus.id
}

resource "aws_security_group" "nexus" {
  name        = "master"
  description = "Security group for master"
  vpc_id      = aws_vpc.nexus.id

  dynamic "ingress" {
    for_each = var.MASTER_SG_RULES_INGRESS
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      cidr_blocks = split(",", ingress.value["cidr_blocks"])
      protocol    = ingress.value["protocol"]
    }
  }

  dynamic "egress" {
    for_each = var.MASTER_SG_RULES_EGRESS
    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      cidr_blocks = split(",", egress.value["cidr_blocks"])
      protocol    = egress.value["protocol"]
    }
  }

  tags = { for k, v in var.TAGS : k => lower(v) }
}
