resource "aws_vpc_peering_connection" "default" {

  count = var.is_peering_required ? 1 : 0

  // acceptor or aws default vpc id
  peer_vpc_id   = data.aws_vpc.default.id

  // Requestor or our VPC id
  vpc_id        = aws_vpc.main.id

  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = merge(
    local.common_tags,
    var.peering_vpc_tags,
    {
      // Peering connection name = roboshop-dev-default
      Name = "${var.project}-${var.environment}-default"
    }
  )
}