
resource "aws_iam_role_policy_attachment" "eks-cluster-esb" {
  for_each   = toset(var.cluster_names)
  policy_arn = aws_iam_policy.esb[each.value].arn
  role       = aws_iam_role.eks-node-group-role[each.value].name
}


resource "aws_eks_addon" "ebs_csi_driver" {
  for_each     = toset(var.cluster_names)
  addon_name   = "aws-ebs-csi-driver"
  cluster_name = each.value
}

resource "aws_eks_addon" "vpc_cni" {
  for_each     = toset(var.cluster_names)
  addon_name   = "vpc-cni"
  cluster_name = each.value
}

resource "aws_eks_addon" "kube-proxy" {
  for_each     = toset(var.cluster_names)
  addon_name   = "kube-proxy"
  cluster_name = each.value
}

resource "aws_eks_addon" "coredns" {
  for_each     = toset(var.cluster_names)
  addon_name   = "coredns"
  cluster_name = each.value
}

resource "aws_eks_addon" "cloudwatch" {
  for_each             = toset(var.cluster_names)
  addon_name           = "amazon-cloudwatch-observability"
  configuration_values = "{ \"containerLogs\": { \"enabled\": false } }"
  cluster_name         = each.value
}
