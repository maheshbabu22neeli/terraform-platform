# terraform-platform
terraform-platform is to create all aws resources

# AWS-VPC Architecture
![AWS_VPC.drawio.svg](aws-vpc/images/AWS_VPC.drawio.svg)

## Features
- VPC with configurable CIDR block and DNS hostname support
- Public, private, and database subnet tiers across multiple Availability Zones
- Internet Gateway for public subnets
- NAT Gateway (with Elastic IP) for private and database subnet outbound access
- Separate route tables for each subnet tier
- Optional VPC peering support flag
- Fully customizable tags on every resource

## Requirements

| Name      | Version |
|-----------|---------|
| terraform | >= 1.0  |
| aws       | >= 5.0  |


## Provider

| Name | Version |
|------|---------|
| aws  | >= 5.0  |


## Inputs

| Name                      | Description                                                                         | Type         | Default                            | Required |
|---------------------------|-------------------------------------------------------------------------------------|--------------|------------------------------------|----------|
| project                   | Project name used for naming and tagging resources                                  | string       | n/a                                | yes      |
| environment               | Deployment environment. Must be one of: dev, qa, uat, prod                          | string       | n/a                                | yes      |
| vpc_cidr                  | CIDR block for the VPC                                                              | string       | `"10.0.0.0/16"`                    | no       |
| public_subnet_cidrs       | List of CIDR blocks for public subnets. One subnet is created per AZ                | list(string) | `["10.0.1.0/24", "10.0.2.0/24"]`   | no       |
| private_subnet_cidrs      | List of CIDR blocks for private subnets. One subnet is created per AZ               | list(string) | `["10.0.11.0/24", "10.0.12.0/24"]` | no       |
| database_subnet_cidrs     | List of CIDR blocks for database subnets. One subnet is created per AZ              | list(string) | `["10.0.21.0/24", "10.0.22.0/24"]` | no       |
| vpc_tags                  | Additional tags to merge on the VPC resource                                        | map(string)  | `{}`                               | no       |
| igw_tags                  | Additional tags to merge on the Internet Gateway                                    | map(string)  | `{}`                               | no       |
| public_subnet_tags        | Additional tags to merge on public subnets                                          | map(string)  | `{}`                               | no       |
| private_subnet_tags       | Additional tags to merge on private subnets                                         | map(string)  | `{}`                               | no       |
| database_subnet_tags      | Additional tags to merge on database subnets                                        | map(string)  | `{}`                               | no       |
| public_route_table_tags   | Additional tags to merge on the public route table                                  | map(string)  | `{}`                               | no       |
| private_route_table_tags  | Additional tags to merge on the private route table                                 | map(string)  | `{}`                               | no       |
| database_route_table_tags | Additional tags to merge on the database route table                                | map(string)  | `{}`                               | no       |
| eip_tags                  | Additional tags to merge on the Elastic IP                                          | map(string)  | `{}`                               | no       |
| nat_gateway_tags          | Additional tags to merge on the NAT Gateway                                         | map(string)  | `{}`                               | no       |
| is_peering_required       | Whether VPC peering is required. Enables peering-related resources when set to true | bool         | `false`                            | no       |

## Outputs

> Outputs should be defined in your `outputs.tf`. Common outputs from this module include:

| Name                | Description                    |
|---------------------|--------------------------------|
| vpc_id              | The ID of the VPC              |
| public_subnet_ids   | List of public subnet IDs      |
| private_subnet_ids  | List of private subnet IDs     |
| database_subnet_ids | List of database subnet IDs    |
| nat_gateway_id      | The ID of the NAT Gateway      |
| internet_gateway_id | The ID of the Internet Gateway |