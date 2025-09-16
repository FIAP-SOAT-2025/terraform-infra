resource "aws_iam_role" "ebs_csi_driver_role" {
  name = "AmazonEKS_EBS_CSI_DriverRole_${var.projectName}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver_role.name
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

resource "kubectl_manifest" "ebs_csi_service_account" {
  depends_on = [
    aws_eks_addon.ebs_csi_driver
  ]
  
  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    eks.amazonaws.com/role-arn: ${aws_iam_role.ebs_csi_driver_role.arn}
  labels:
    app.kubernetes.io/component: csi-driver
    app.kubernetes.io/name: aws-ebs-csi-driver
  name: ebs-csi-controller-sa
  namespace: kube-system
YAML
}
