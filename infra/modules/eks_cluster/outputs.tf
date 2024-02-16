
output "clusters" {
  value = aws_eks_cluster.cluster

  depends_on = [
    aws_eks_node_group.nodeGroup
  ]
}

output "oidc_provider" {
  value = aws_iam_openid_connect_provider.cluster
}
