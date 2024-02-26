
module "oap" {
  source                 = "../modules/oap"
  storage_type           = var.storage_type
  elasticsearch_host     = var.elasticsearch_host
  elasticsearch_user     = var.elasticsearch_user
  elasticsearch_password = var.elasticsearch_password
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}

module "istio" {
  count        = var.enable_istio ? 1 : 0
  source       = "../modules/istio"
  oap_endpoint = module.oap.oap_endpoint
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}

module "monitoring" {
  source = "../modules/monitoring"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}

resource "aws_eks_addon" "ebs_csi_driver" {
  addon_name   = "aws-ebs-csi-driver"
  cluster_name = var.kube_cluster
}

resource "aws_eks_addon" "vpc_cni" {
  addon_name   = "vpc-cni"
  cluster_name = var.kube_cluster
}

resource "aws_eks_addon" "kube-proxy" {
  addon_name   = "kube-proxy"
  cluster_name = var.kube_cluster
}

resource "aws_eks_addon" "coredns" {
  addon_name   = "coredns"
  cluster_name = var.kube_cluster
}

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
}
