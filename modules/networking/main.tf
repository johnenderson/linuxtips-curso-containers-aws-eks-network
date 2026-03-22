locals {
  default_tags = merge({
    Name = var.project_name
  }, var.tags)

  public_tags  = merge(local.default_tags, var.public_subnet_tags)
  private_tags = merge(local.default_tags, var.private_subnet_tags)
  db_tags      = merge(local.default_tags, var.database_subnet_tags)
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = local.default_tags
}

resource "aws_vpc_ipv4_cidr_block_association" "main" {
  count      = length(var.vpc_additional_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_additional_cidrs[count.index]
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.default_tags, { "Name" = "${var.project_name}-igw" })
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index].cidr
  availability_zone = var.public_subnets[count.index].availability_zone

  tags = merge(local.public_tags, {
    "Name" = var.public_subnets[count.index].name
  })

  depends_on = [aws_vpc_ipv4_cidr_block_association.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags, { "Name" = "${var.project_name}-public-rt" })
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count  = var.enable_nat_gateway ? length(var.public_subnets) : 0
  domain = "vpc"

  tags = merge(local.default_tags, { "Name" = "${var.project_name}-nat-eip-${count.index + 1}" })
}

resource "aws_nat_gateway" "main" {
  count         = var.enable_nat_gateway ? length(var.public_subnets) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags       = merge(local.default_tags, { "Name" = "${var.project_name}-nat-${count.index + 1}" })
  depends_on = [aws_internet_gateway.main]
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index].cidr
  availability_zone = var.private_subnets[count.index].availability_zone

  tags = merge(local.private_tags, {
    "Name" = var.private_subnets[count.index].name
  })

  depends_on = [aws_vpc_ipv4_cidr_block_association.main]
}

resource "aws_route_table" "private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags, { "Name" = "${var.project_name}-private-rt-${count.index + 1}" })
}

resource "aws_route" "private" {
  count = var.enable_nat_gateway ? length(var.private_subnets) : 0

  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.main[
    index(var.public_subnets[*].availability_zone, var.private_subnets[count.index].availability_zone)
  ].id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

resource "aws_subnet" "database" {
  count = length(var.database_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnets[count.index].cidr
  availability_zone = var.database_subnets[count.index].availability_zone

  tags = merge(local.db_tags, {
    "Name" = var.database_subnets[count.index].name
  })

  depends_on = [aws_vpc_ipv4_cidr_block_association.main]
}

resource "aws_network_acl" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags, { "Name" = "${var.project_name}-database-nacl" })
}

resource "aws_network_acl_rule" "database" {
  count = length(var.database_nacl_rules)

  network_acl_id = aws_network_acl.database.id
  rule_number    = var.database_nacl_rules[count.index].rule_number
  rule_action    = var.database_nacl_rules[count.index].rule_action
  protocol       = var.database_nacl_rules[count.index].protocol
  egress         = var.database_nacl_rules[count.index].egress
  cidr_block     = var.database_nacl_rules[count.index].cidr_block
  from_port      = var.database_nacl_rules[count.index].from_port
  to_port        = var.database_nacl_rules[count.index].to_port
}

resource "aws_network_acl_association" "database" {
  count = length(var.database_subnets)

  subnet_id      = aws_subnet.database[count.index].id
  network_acl_id = aws_network_acl.database.id
}

resource "aws_security_group" "default" {
  count       = var.create_default_sg ? 1 : 0
  name        = "${var.project_name}-default-sg"
  description = "Security group created by networking module"
  vpc_id      = aws_vpc.main.id

  tags = merge(local.default_tags, { "Name" = "${var.project_name}-default-sg" })
}

resource "aws_security_group_rule" "custom" {
  count = var.create_default_sg ? length(var.security_group_rules) : 0

  security_group_id = aws_security_group.default[0].id

  type        = var.security_group_rules[count.index].type
  protocol    = var.security_group_rules[count.index].protocol
  from_port   = var.security_group_rules[count.index].from_port
  to_port     = var.security_group_rules[count.index].to_port
  cidr_blocks = var.security_group_rules[count.index].cidr_blocks

  description = var.security_group_rules[count.index].description
}

resource "aws_ssm_parameter" "vpc" {
  name  = "/${var.project_name}/vpc/id"
  type  = "String"
  value = aws_vpc.main.id
}

resource "aws_ssm_parameter" "public_subnets" {
  count = length(var.public_subnets)

  name  = "/${var.project_name}/subnets/public/${var.public_subnets[count.index].availability_zone}/${var.public_subnets[count.index].name}"
  type  = "String"
  value = aws_subnet.public[count.index].id
}

resource "aws_ssm_parameter" "private_subnets" {
  count = length(var.private_subnets)

  name  = "/${var.project_name}/subnets/private/${var.private_subnets[count.index].availability_zone}/${var.private_subnets[count.index].name}"
  type  = "String"
  value = aws_subnet.private[count.index].id
}

resource "aws_ssm_parameter" "database_subnets" {
  count = length(var.database_subnets)

  name  = "/${var.project_name}/subnets/database/${var.database_subnets[count.index].availability_zone}/${var.database_subnets[count.index].name}"
  type  = "String"
  value = aws_subnet.database[count.index].id
}
