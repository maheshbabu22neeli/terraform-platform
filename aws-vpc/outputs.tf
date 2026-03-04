output "out_azs" {
  value = data.aws_availability_zones.available
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}