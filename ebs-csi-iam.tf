

resource "kubectl_manifest" "ebs_csi_service_account" {
  depends_on = [
    aws_eks_cluster.cluster,
    aws_eks_node_group.node_group,
    aws_eks_addon.ebs_csi_driver
  ]
  
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole
  labels:
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/name: aws-ebs-csi-driver
  name: ebs-csi-controller-sa
  namespace: kube-system
YAML
}
