terraform {
  backend "s3" {
    bucket         = "terraform-state-tc3-g38-lanchonete"
    key            = "infra/terraform.tfstate"
    region         = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.19.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.auth.token
  }
}

provider "aws" {
  region = var.aws_region
}

provider "kubectl" {
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.auth.token
  load_config_file       = false
}

data "aws_caller_identity" "current" {}

locals {
  availability_zones = ["us-east-1a", "us-east-1b"]
}

data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.cluster.name
}

data "aws_eks_cluster_auth" "auth" {
  name = aws_eks_cluster.cluster.name
}


output "cluster_name" {
  description = "Nome do cluster EKS"
  value       = aws_eks_cluster.cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = aws_eks_cluster.cluster.endpoint
}

output "cluster_security_group_id" {
  description = "Security group ID do cluster EKS"
  value       = aws_security_group.sg.id
}

output "vpc_id" {
  description = "ID da VPC"
  value       = aws_vpc.vpc_TC3_G38.id
}

output "private_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = aws_subnet.subnet_public[*].id
}

output "aws_region" {
  description = "Região AWS"
  value       = var.aws_region
}