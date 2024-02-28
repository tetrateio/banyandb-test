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
  set {
    name  = "global.proxy.resources.requests.cpu"
    value = "100m"
  }
  set {
    name  = "global.proxy.resources.requests.memory"
    value = "128Mi"
  }
  set {
    name  = "global.proxy.resources.limits.cpu"
    value = "2000m"
  }
  set {
    name  = "global.proxy.resources.limits.memory"
    value = "1024Mi"
  }
}

resource "helm_release" "istio_ingress" {
  name       = "istio-ingress"
  repository = "https://istio-release.storage.googleapis.com/charts"
  chart      = "gateway"
  namespace  = kubernetes_namespace.istio_system.metadata.0.name
  depends_on = [helm_release.istiod]
}
