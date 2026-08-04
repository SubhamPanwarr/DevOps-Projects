aws_region         = "us-east-1"
project_name       = "eks-cicd"
environment        = "dev"
cluster_name       = "my-eks-cluster"
kubernetes_version = "1.35"

vpc_name = "eks-vpc"
vpc_cidr = "192.168.0.0/16"

public_subnets = [
  "192.168.1.0/24",
  "192.168.2.0/24",
  "192.168.3.0/24"
]

private_subnets = [
  "192.168.4.0/24",
  "192.168.5.0/24",
  "192.168.6.0/24"
]

node_instance_types = [
  "t3.medium"
]

node_capacity_type = "ON_DEMAND"
