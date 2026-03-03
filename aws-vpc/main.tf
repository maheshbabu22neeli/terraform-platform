// create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cider
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = local.vpc_final_tags
}

// create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = local.igw_final_tags
}

// create Subnet's
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.public_subnet_final_tags,
    {
      # roboshop-dev-public-us-east-1a
      Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(
    local.private_subnet_final_tags,
    {
      # roboshop-dev-private-us-east-1a
      Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
    }
  )
}

resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(
    local.database_subnet_final_tags,
    {
      # roboshop-dev-database-us-east-1a
      Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
    }
  )
}

// create Route Tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.route_table_public_final_tags,
    {
      # roboshop-dev-public
      Name = "${var.project}-${var.environment}-public"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.route_table_private_final_tags,
    {
      # roboshop-dev-private
      Name = "${var.project}-${var.environment}-private"
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.route_table_database_final_tags,
    {
      # roboshop-dev-database
      Name = "${var.project}-${var.environment}-database"
    }
  )
}

// create Route's for Route Tables
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0" # Providing Internet Access
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_eip" "nat" {
  domain   = "vpc"
  tags = merge(
    local.eip_nat_final_tags,
    {
      Name = "${var.project}-${var.environment}-nat"
    }
  )
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # we are creating aws_nat_gateway only in us-east-1a AZ

  tags = merge(
    local.nat_gw_final_tags,
    {
      Name = "${var.project}-${var.environment}"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"              // provide internet ngress access through NAT GW
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "database" {
  route_table_id         = aws_route_table.database.id
  destination_cidr_block = "0.0.0.0/0"              // provide internet ngress access through NAT GW
  nat_gateway_id = aws_nat_gateway.main.id
}

// Associate Subnets to Route Tables
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}
