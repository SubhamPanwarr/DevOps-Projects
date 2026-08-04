locals {
  availability_zones = slice(
    data.aws_availability_zones.available.names,
    0,
    length(var.private_subnets)
  )
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = local.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_dns_support   = true
  enable_dns_hostnames = true

  map_public_ip_on_launch = true

  enable_nat_gateway = true

  # Lab configuration: one NAT Gateway instead of one per AZ.
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  tags = {
    Name                                        = var.vpc_name
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}
