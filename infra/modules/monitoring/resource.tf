resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  values     = [file("../templates/prometheus.yml")]
}

data "kubernetes_service" "prometheus" {
  metadata {
    name      = "prometheus-server"
    namespace = helm_release.prometheus.metadata[0].namespace
  }
}

output "dashboard" {
  value = "http://${data.kubernetes_service.prometheus.status[0].load_balancer[0].ingress[0].hostname}/graph?g0.expr=histogram_quantile(0.95%2C%20rate(persistence_timer_bulk_execute_latency_bucket%5B5m%5D))&g0.tab=0&g0.display_mode=lines&g0.show_exemplars=1&g0.range_input=30m&g0.end_input=2024-02-27%2006%3A40%3A00&g0.moment_input=2024-02-27%2006%3A40%3A00&g1.expr=rate(process_cpu_seconds_total%5B1m%5D)%20*%20100&g1.tab=0&g1.display_mode=lines&g1.show_exemplars=0&g1.range_input=1h"
}
output "grpc" {
  value = "http://${data.kubernetes_service.prometheus.status[0].load_balancer[0].ingress[0].hostname}/graph?g0.expr=sum(rate(grpc_server_started_total%7Bgrpc_type!%3D%22unary%22%7D%5B5m%5D))%20by%20(grpc_service%2C%20grpc_method)&g0.tab=0&g0.display_mode=lines&g0.show_exemplars=0&g0.range_input=1h&g1.expr=histogram_quantile(0.95%2C%20sum(rate(grpc_server_handling_seconds_bucket%7Bgrpc_type!%3D%22unary%22%7D%5B5m%5D))%20by%20(grpc_service%2Cgrpc_method%2C%20le))&g1.tab=0&g1.display_mode=lines&g1.show_exemplars=0&g1.range_input=1h&g2.expr=grpc_server_started_total&g2.tab=1&g2.display_mode=lines&g2.show_exemplars=0&g2.range_input=1h"
}
