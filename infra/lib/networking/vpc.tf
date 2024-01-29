## AWS VPC management

# because EKS: https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html
# each subnet has to be tagged with "kubernetes.io/cluster/<cluster-name> => shared"
# for k8s to be able to discover it (k8s <=1.14)
locals {
  shared_tags = { for name in var.cluster_names : "kubernetes.io/cluster/${name}" => "shared" }
  tags = {
    Name = var.vpc_name,
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(
    local.shared_tags,
    {
      Name = var.vpc_name,
  })
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.vpc_secondary_cidr
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.main.id
}
