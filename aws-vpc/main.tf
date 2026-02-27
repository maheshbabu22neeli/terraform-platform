resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cider
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = local.igw_final_tags
}




/*resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]
  #availability_zone   = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Main"
  }
}*/