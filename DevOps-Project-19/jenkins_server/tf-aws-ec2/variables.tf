variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "eks-cicd"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "existing_vpc_id" {
  description = "Existing VPC where Jenkins will be deployed"
  type        = string
}

variable "existing_public_subnet_id" {
  description = "Existing public subnet for the Jenkins instance"
  type        = string
}

variable "instance_type" {
  description = "Jenkins EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "key_name" {
  description = "Existing EC2 key-pair name"
  type        = string
}

variable "admin_cidr" {
  description = "CIDR permitted to access SSH, Jenkins and SonarQube"
  type        = string
}
