variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name used for resource tagging"
  type        = string
  default     = "eks-cicd"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Amazon EKS cluster name"
  type        = string
  default     = "my-eks-cluster"
}

variable "kubernetes_version" {
  description = "Amazon EKS Kubernetes version"
  type        = string
  default     = "1.35"
}

variable "vpc_name" {
  description = "Name of the EKS VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR range for the EKS VPC"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDR ranges"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR ranges"
  type        = list(string)
}

variable "node_instance_types" {
  description = "EC2 instance types for EKS managed nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_capacity_type" {
  description = "EKS node capacity type"
  type        = string
  default     = "ON_DEMAND"

  validation {
    condition = contains(
      ["ON_DEMAND", "SPOT"],
      var.node_capacity_type
    )

    error_message = "node_capacity_type must be ON_DEMAND or SPOT."
  }
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR ranges permitted to access the public EKS API endpoint"
  type        = list(string)
}
