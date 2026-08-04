module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  endpoint_private_access = true
  endpoint_public_access  = true

  # Adds the Terraform caller through an EKS access entry.
  enable_cluster_creator_admin_permissions = true

  enable_irsa = true

  addons = {
    coredns = {}

    kube-proxy = {}

    vpc-cni = {
      before_compute = true
    }

    eks-pod-identity-agent = {
      before_compute = true
    }
  }

  enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    nodes = {
      name = "${var.cluster_name}-nodes"

      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.node_instance_types
      capacity_type  = var.node_capacity_type

      min_size     = 2
      max_size     = 3
      desired_size = 2

      disk_size = 30

      labels = {
        role        = "application"
        environment = var.environment
      }

      update_config = {
        max_unavailable = 1
      }

      tags = {
        Name = "${var.cluster_name}-node"
      }
    }
  }

  tags = {
    Name = var.cluster_name
  }
}
