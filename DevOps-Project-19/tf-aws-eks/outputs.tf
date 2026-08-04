output "aws_account_id" {
  description = "AWS account where the cluster was deployed"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

output "cluster_name" {
  description = "Amazon EKS cluster name"
  value       = var.cluster_name
}

output "cluster_endpoint" {
  description = "Amazon EKS API endpoint"
  value       = module.eks.cluster_endpoint
}

output "vpc_id" {
  description = "EKS VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "configure_kubectl" {
  description = "Command for configuring kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}
