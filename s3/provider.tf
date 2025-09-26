terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.13.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

output "aws_region" {
  description = "Região AWS"
  value       = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy the resources"
  default     = "us-east-1"
}