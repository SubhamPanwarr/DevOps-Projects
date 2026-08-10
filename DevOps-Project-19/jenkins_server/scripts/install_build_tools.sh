#!/bin/bash
set -euxo pipefail

dnf update -y

dnf install -y \
  wget \
  unzip \
  tar \
  gzip \
  git \
  jq \
  fontconfig \
  java-21-amazon-corretto-devel \
  docker \
  dnf-plugins-core

# Docker
systemctl enable --now docker

usermod -aG docker ec2-user

# Jenkins
wget -O /etc/yum.repos.d/jenkins.repo \
  https://pkg.jenkins.io/rpm-stable/jenkins.repo

dnf install -y jenkins

usermod -aG docker jenkins

systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

# AWS CLI v2
cd /tmp

curl -fsSLo awscliv2.zip \
  https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip

rm -rf aws
unzip -q awscliv2.zip
./aws/install --update

# Terraform
dnf config-manager --add-repo \
  https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

dnf install -y terraform

# kubectl for EKS 1.35
curl -fsSLo /usr/local/bin/kubectl \
  https://s3.us-west-2.amazonaws.com/amazon-eks/1.35.3/2026-04-08/bin/linux/amd64/kubectl

chmod +x /usr/local/bin/kubectl

# eksctl
curl -fsSLo /tmp/eksctl.tar.gz \
  https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_amd64.tar.gz

tar -xzf /tmp/eksctl.tar.gz \
  -C /usr/local/bin

chmod +x /usr/local/bin/eksctl

# Helm 3
curl -fsSLo /tmp/get_helm.sh \
  https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 /tmp/get_helm.sh
/tmp/get_helm.sh

# Trivy
cat > /etc/yum.repos.d/trivy.repo <<'TRIVY'
[trivy]
name=Trivy repository
baseurl=https://aquasecurity.github.io/trivy-repo/rpm/releases/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://aquasecurity.github.io/trivy-repo/rpm/public.key
TRIVY

dnf install -y trivy

# SonarQube host requirements
cat > /etc/sysctl.d/99-sonarqube.conf <<'SYSCTL'
vm.max_map_count=524288
fs.file-max=131072
SYSCTL

sysctl --system

docker run -d \
  --name sonarqube \
  --restart unless-stopped \
  -p 9000:9000 \
  sonarqube:lts-community

# Apply Jenkins docker-group membership
systemctl restart jenkins
