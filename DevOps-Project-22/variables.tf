variable "region" {
  description = "AWS Region used for all Project 22 resources."
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "Local AWS CLI profile used by Terraform."
  type        = string
  default     = "devops-admin"
}

variable "cidr_block" {
  description = "CIDR block for the isolated application VPC."
  type        = string
  default     = "10.22.0.0/16"
}

variable "private_subnets" {
  description = "Number of private subnets to create across available Availability Zones."
  type        = number
  default     = 2

  validation {
    condition     = var.private_subnets >= 2
    error_message = "At least two private subnets are required for the Aurora DB subnet group."
  }
}

variable "database" {
  description = "Initial Aurora MySQL database name."
  type        = string
  default     = "webapp"
}

variable "aurora_engine_version" {
  description = "Aurora MySQL version verified for db.serverless in the selected Region."
  type        = string
  default     = "8.0.mysql_aurora.3.12.0"
}

variable "api_stage" {
  description = "API Gateway deployment stage and resource-name suffix."
  type        = string
  default     = "dev"
}

variable "lambda_memory_size" {
  description = "Memory allocated to the API Lambda function in MiB."
  type        = number
  default     = 512

  validation {
    condition     = var.lambda_memory_size >= 128 && var.lambda_memory_size <= 10240
    error_message = "Lambda memory must be between 128 and 10240 MiB."
  }
}

variable "enable_custom_domain" {
  description = "Create ACM, API Gateway custom-domain, and Route 53 integrations."
  type        = bool
  default     = false
}

variable "domain" {
  description = "API hostname, for example api.example.com. Used only when enable_custom_domain is true."
  type        = string
  default     = ""
}

variable "hosted_zone_name" {
  description = "Public Route 53 hosted-zone name, for example example.com."
  type        = string
  default     = ""
}
