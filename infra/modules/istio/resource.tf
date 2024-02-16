resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "base"
  namespace  = kubernetes_namespace.istio_system.metadata[0].name
}

resource "helm_release" "istiod" {
  name       = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "istiod"
  namespace  = kubernetes_namespace.istio_system.metadata[0].name
  depends_on = [helm_release.istio_base]
  set {
    name  = "meshConfig.defaultConfig.envoyMetricsService.address"
    value = var.oap_endpoint
  }
  set {
    name  = "meshConfig.defaultConfig.envoyAccessLogService.address"
    value = var.oap_endpoint
  }
  set {
    name  = "meshConfig.enableEnvoyAccessLogService"
    value = true
  }
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = kubernetes_namespace.istio_system.metadata.0.name
  depends_on = [helm_release.istiod]
}
