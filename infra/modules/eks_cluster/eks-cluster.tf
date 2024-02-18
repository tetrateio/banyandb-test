### AWS EKS management

# Create IAM roles for corresponding clusters
resource "aws_iam_role" "eks-cluster-role" {
  for_each = toset(var.cluster_names)
  name     = "eks-cluster-role-${each.value}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attach policies to created roles
resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  for_each   = toset(var.cluster_names)
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role[each.value].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  for_each   = toset(var.cluster_names)
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-cluster-role[each.value].name
}

# EKS MP Cluster definition
resource "aws_eks_cluster" "cluster" {
  for_each = toset(var.cluster_names)
  name     = each.value
  role_arn = aws_iam_role.eks-cluster-role[each.value].arn
  version  = var.eks_k8s_version

  vpc_config {
    subnet_ids = values(var.subnet_ids)
  }
}
