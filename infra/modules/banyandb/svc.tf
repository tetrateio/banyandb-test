
resource "kubernetes_service" "banyand_service" {
  metadata {
    name      = "banyand"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "banyand"
    }
    port {
      name        = "grpc"
      port        = 17912
      target_port = 17912
    }
  }
}

resource "kubernetes_service" "banyand_prometheus" {
  metadata {
    name      = "banyand-prometheus"
    namespace = var.namespace
    labels = {
      app = "banyand-prometheus"
    }
  }

  spec {
    selector = {
      app = "banyand"
    }

    port {
      name        = "monitoring"
      port        = 2121
      target_port = 2121
    }

    session_affinity = "ClientIP"
  }
}

resource "kubernetes_service" "banyand_service_external" {
  metadata {
    name      = "banyand-external"
    namespace = var.namespace
  }
  spec {
    selector = {
      app = "banyand"
    }
    type = "LoadBalancer"
    port {
      name        = "http"
      port        = 17913
      target_port = 17913
    }
  }
}