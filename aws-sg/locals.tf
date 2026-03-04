locals {

  common_tags = {
    Project     = var.project
    Environment = var.environment
    Terraform   = "true"
  }

  sg_final_tags = merge(
    local.common_tags,
    var.sg_tags
  )

}