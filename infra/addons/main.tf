
module "banyandb" {
  count  = var.storage_type == "banyandb" ? 1 : 0
  source = "../modules/banyandb"
  providers = {
    kubernetes = kubernetes
    helm       = helm
  }
}

module "oap" {
  source                 = "../modules/oap"
  storage_type           = var.storage_type
  elasticsearch_host     = var.elasticsearch_host
  elasticsearch_user     = var.elasticsearch_user
  elasticsearch_password = var.elasticsearch_password
  banyandb_host          = length(module.banyandb) > 0 ? module.banyandb[0].banyandb_host : null
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

resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
}
