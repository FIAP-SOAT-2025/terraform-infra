variable "aws_region" {
  description = "The AWS region to deploy the resources"
  default     = "us-east-1"
}


variable "projectName" {
  description = "The name of the project"
  default     = "tc4-lanchonete-v1"
}

variable "cidr_vpc" {
  description = "The CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "tags" {
  description = "A map of tags to assign to all resources"
  default = {
    Name = "tc4-lanchonete-v1"
  }
}

variable "node_instance_type" {
  description = "EC2 instance type for the EKS worker nodes"
  default     = "t3.medium"
}