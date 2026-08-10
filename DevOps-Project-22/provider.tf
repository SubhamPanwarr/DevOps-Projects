provider "aws" {
  region  = var.region
  profile = var.aws_profile

  default_tags {
    tags = {
      Project     = "DevOps-Project-22"
      Environment = var.api_stage
      ManagedBy   = "Terraform"
    }
  }
}
