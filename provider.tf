terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.13.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "~> 1.19.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
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