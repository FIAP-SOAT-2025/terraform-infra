resource "aws_eks_access_entry" "user_access" {
  cluster_name  = aws_eks_cluster.cluster.name
  principal_arn = "arn:aws:iam::323583190836:user/estudo-terraform"
  type          = "STANDARD"

  depends_on = [aws_eks_cluster.cluster]
}

resource "aws_eks_access_policy_association" "user_admin_policy" {
  cluster_name  = aws_eks_cluster.cluster.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = "arn:aws:iam::323583190836:user/estudo-terraform"
  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.user_access]
}