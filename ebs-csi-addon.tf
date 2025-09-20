resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name                = aws_eks_cluster.cluster.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = "v1.35.0-eksbuild.1"
  resolve_conflicts_on_create = "OVERWRITE"
  service_account_role_arn    = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"

  depends_on = [
    aws_eks_node_group.node_group
  ]
}
