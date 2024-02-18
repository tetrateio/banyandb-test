
output "clusters" {
  value = aws_eks_cluster.cluster

  depends_on = [
    aws_eks_node_group.nodeGroup
  ]
}
