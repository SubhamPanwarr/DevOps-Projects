aws_region   = "us-east-1"
project_name = "eks-cicd"
environment  = "dev"

existing_vpc_id           = "vpc-0553fa7a90534e35c"
existing_public_subnet_id = "subnet-014d2a061207102aa"

instance_type = "t3.large"
key_name      = "jenkins_server_keypair"
admin_cidr    = "49.36.176.119/32"
