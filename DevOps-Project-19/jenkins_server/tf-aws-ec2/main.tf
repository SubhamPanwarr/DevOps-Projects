locals {
  ingress_ports = {
    ssh = {
      port        = 22
      description = "SSH"
    }

    jenkins = {
      port        = 8080
      description = "Jenkins UI"
    }

    sonarqube = {
      port        = 9000
      description = "SonarQube UI"
    }
  }
}

resource "aws_security_group" "jenkins" {
  name        = "${var.project_name}-jenkins-sg"
  description = "Restricted access to Jenkins server"
  vpc_id      = var.existing_vpc_id

  tags = {
    Name = "${var.project_name}-jenkins-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins" {
  for_each = local.ingress_ports

  security_group_id = aws_security_group.jenkins.id
  description       = each.value.description

  cidr_ipv4   = var.admin_cidr
  ip_protocol = "tcp"
  from_port   = each.value.port
  to_port     = each.value.port
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.jenkins.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_iam_role" "jenkins" {
  name               = "${var.project_name}-jenkins-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = {
    Name = "${var.project_name}-jenkins-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Lab access. Replace later with a least-privilege policy.
resource "aws_iam_role_policy_attachment" "administrator_lab" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.project_name}-jenkins-profile"
  role = aws_iam_role.jenkins.name
}

resource "aws_instance" "jenkins" {
  ami           = nonsensitive(data.aws_ssm_parameter.al2023.value)
  instance_type = var.instance_type
  key_name      = var.key_name

  subnet_id                   = var.existing_public_subnet_id
  vpc_security_group_ids      = [aws_security_group.jenkins.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name

  monitoring = true

  user_data                   = file("${path.module}/../scripts/install_build_tools.sh")
  user_data_replace_on_change = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 50
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm,
    aws_iam_role_policy_attachment.administrator_lab
  ]

  tags = {
    Name = "${var.project_name}-jenkins"
  }
}
