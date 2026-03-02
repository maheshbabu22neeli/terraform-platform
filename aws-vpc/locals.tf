locals {

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }

  vpc_final_tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}"
    },
    var.vpc_tags
  )

  igw_final_tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}"
    },
    var.igw_tags
  )

  // [us-east-1a, us-east-1b]
  az_names = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnet_final_tags = merge(
    local.common_tags,
    var.public_subnet_tags
  )

  private_subnet_final_tags = merge(
    local.common_tags,
    var.private_subnet_tags
  )

  database_subnet_final_tags = merge(
    local.common_tags,
    var.database_subnet_tags
  )

  route_table_public_final_tags = merge(
    local.common_tags,
    var.route_table_public_tags
  )

  route_table_private_final_tags = merge(
    local.common_tags,
    var.route_table_private_tags
  )

  route_table_database_final_tags = merge(
    local.common_tags,
    var.route_table_database_tags
  )

  eip_nat_final_tags = merge(
    local.common_tags,
    var.eip_nat_tags
  )

  nat_gw_final_tags = merge(
    local.common_tags,
    var.nat_gw_tags
  )

}