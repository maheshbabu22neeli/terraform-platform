resource "aws_security_group" "main" {

  name        = "${var.project}-${var.environment}-${var.sg_name}" // roboshop-dev-mongodb  // roboshop-dev-catalogue
  description = "Allow TLS inbound traffic for Project ${var.project} in '${var.environment}' for component '${var.sg_name}'"
  vpc_id      = var.vpc_id

  // we can allow out going traffic from our instances
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = merge(
    local.sg_final_tags,
    {
      Name = "${var.project}-${var.environment}-${var.sg_name}"
    }
  )
}