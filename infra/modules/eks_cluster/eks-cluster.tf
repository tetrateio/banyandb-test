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

# OpenID Connect setup, in 2020 there's no other way but ugly hackery!
# see https://github.com/hashicorp/terraform-provider-tls/issues/52 for the ugliness justification
#
# Gotta have OpenID to be able to grant IAM permissions for pods based on Service Accounts, see:
# https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/
#
# Because AWS is not a service, but a collection of regions, we need to obtain the root CA fingerprint, depending on which region we are in:
# https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/
# TODO(denis): rewrite at least in py instead of bash
data "external" "thumbprint" {
  program = [format("%s/ugly_scripts/eks_rootca_thumbprint.sh", path.module), data.aws_region.current.name]
}

resource "aws_iam_openid_connect_provider" "cluster" {
  for_each        = toset(var.cluster_names)
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result.thumbprint]
  url             = aws_eks_cluster.cluster[each.value].identity.0.oidc.0.issuer

  depends_on = [
    aws_eks_cluster.cluster
  ]
}
