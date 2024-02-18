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

  set {
    name  = "serverFiles.prometheus\\.yml"
    value = file("../templates/prometheus.yml")
  }
  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}
