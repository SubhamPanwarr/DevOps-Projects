terraform {
  backend "s3" {
    bucket = "terraform-eks-cicd-248847837354-us-east-1"
    key    = "eks/terraform.tfstate"
    region = "us-east-1"
  }
}
