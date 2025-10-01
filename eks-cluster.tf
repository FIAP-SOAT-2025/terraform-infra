resource "aws_eks_cluster" "cluster" {
  name = "eks-${var.projectName}"

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  version  = "1.31"

  vpc_config {
    subnet_ids = concat(
      aws_subnet.subnet_public[*].id,
      aws_subnet.subnet_private[*].id
    )
    security_group_ids = [aws_security_group.sg.id]
  }
}
