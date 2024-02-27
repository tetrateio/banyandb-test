
# IAM role for the nodepool

resource "aws_iam_role" "eks-node-group-role" {
  for_each           = toset(var.cluster_names)
  name               = "${each.value}-node-pool"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  for_each   = toset(var.cluster_names)
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-node-group-role[each.value].name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  for_each   = toset(var.cluster_names)
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-node-group-role[each.value].name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  for_each   = toset(var.cluster_names)
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-node-group-role[each.value].name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  for_each   = toset(var.cluster_names)
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks-node-group-role[each.value].name
}

resource "aws_iam_role_policy_attachment" "AWSXrayWriteOnlyAccess" {
  for_each   = toset(var.cluster_names)
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
  role       = aws_iam_role.eks-node-group-role[each.value].name
}

# Node groups for the passed clusters
# Maybe make at least the size tunable on a per-cluster basis?
# TODO(denis): create node groups actually in different AZs, we're already creating 3 subnets, 1 per AZ

resource "aws_eks_node_group" "nodeGroup" {
  for_each        = toset(var.cluster_names)
  cluster_name    = each.value
  node_group_name = "${each.value}-nodegroup"
  node_role_arn   = aws_iam_role.eks-node-group-role[each.value].arn
  subnet_ids      = [lookup(var.subnet_ids, "${var.region}a")]
  instance_types  = var.worker_instance_types

  scaling_config {
    desired_size = var.node_pool_desired_size
    max_size     = var.node_pool_max_size
    min_size     = var.node_pool_min_size
  }

  depends_on = [
    aws_eks_cluster.cluster
  ]
  # ignore out-of-band (caused by k8s-autoscaler) changes
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}

# Iam policy for cluster-autoscaler

resource "aws_iam_policy" "autoscaler" {
  for_each    = toset(var.cluster_names)
  name        = "autoscaler-${each.value}"
  description = "Policy for cluster autoscaler in cluster ${each.value}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks-cluster-autoscaler" {
  for_each   = toset(var.cluster_names)
  policy_arn = aws_iam_policy.autoscaler[each.value].arn
  role       = aws_iam_role.eks-node-group-role[each.value].name
}

resource "aws_iam_policy" "esb" {
  for_each    = toset(var.cluster_names)
  name        = "esb-controller-${each.value}"
  description = "Policy for esb in cluster ${each.value}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateSnapshot",
        "ec2:AttachVolume",
        "ec2:DetachVolume",
        "ec2:ModifyVolume",
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeInstances",
        "ec2:DescribeSnapshots",
        "ec2:DescribeTags",
        "ec2:DescribeVolumes",
        "ec2:DescribeVolumesModifications"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["ec2:CreateTags"],
      "Resource": ["arn:aws:ec2:*:*:volume/*", "arn:aws:ec2:*:*:snapshot/*"],
      "Condition": {
        "StringEquals": {
          "ec2:CreateAction": ["CreateVolume", "CreateSnapshot"]
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": ["ec2:DeleteTags"],
      "Resource": ["arn:aws:ec2:*:*:volume/*", "arn:aws:ec2:*:*:snapshot/*"]
    },
    {
      "Effect": "Allow",
      "Action": ["ec2:CreateVolume"],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:RequestTag/ebs.csi.aws.com/cluster": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": ["ec2:CreateVolume"],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:RequestTag/CSIVolumeName": "*"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": ["ec2:DeleteVolume"],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/ebs.csi.aws.com/cluster": "true"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": ["ec2:DeleteVolume"],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/CSIVolumeName": "*"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": ["ec2:DeleteVolume"],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/kubernetes.io/created-for/pvc/name": "*"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": ["ec2:DeleteSnapshot"],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/CSIVolumeSnapshotName": "*"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": ["ec2:DeleteSnapshot"],
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "ec2:ResourceTag/ebs.csi.aws.com/cluster": "true"
        }
      }
    }
  ]
}
EOF
}

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
