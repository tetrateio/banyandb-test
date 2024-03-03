
module "banyandb" {
  count  = var.storage_type == "banyandb" ? 1 : 0
  source = "../modules/banyandb"
  providers = {
    kubernetes = kubernetes
  }
  namespace = "sw-system"
}

module "oap" {
  source                 = "../modules/oap"
  storage_type           = var.storage_type
  elasticsearch_host     = var.elasticsearch_host
  elasticsearch_user     = var.elasticsearch_user
  elasticsearch_password = var.elasticsearch_password
  banyandb_targets       = length(module.banyandb) > 0 ? module.banyandb[0].banyandb_targets : null
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

output "monitoring_dashboard" {
  value = module.monitoring.dashboard
}
output "monitoring_grpc" {
  value = module.monitoring.grpc
}