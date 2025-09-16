resource "aws_security_group" "sg" {
    name = "${var.projectName}-sg"
    description = "Security group for ${var.projectName} - Usado para export o service na internet"
    vpc_id = aws_vpc.vpc_TC3_G38.id

    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "HTTPS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "EKS API Server"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = [var.cidr_vpc]
    }

    ingress {
        description = "Node to node communication"
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        self        = true
    }

    ingress {
        description = "Kubelet API"
        from_port   = 10250
        to_port     = 10250
        protocol    = "tcp"
        cidr_blocks = [var.cidr_vpc]
    }

    egress {
        description = "All"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = var.tags
}