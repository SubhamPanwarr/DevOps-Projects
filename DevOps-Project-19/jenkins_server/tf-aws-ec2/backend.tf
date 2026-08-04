terraform {
  backend "s3" {
    bucket       = "terraform-eks-cicd-248847837354-us-east-1"
    key          = "jenkins/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
