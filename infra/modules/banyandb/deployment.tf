resource "kubernetes_deployment" "banyand_deployment" {
  count = var.enabled_deployment_mode ? 1 : 0
  metadata {
    name      = "banyand"
    namespace = var.namespace
    labels = {
      app = "banyand"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "banyand"
      }
    }

    strategy {
      type = "Recreate"
    }

    template {
      metadata {
        labels = {
          app = "banyand"
        }
      }

      spec {
        init_container {
          name    = "cleanup"
          image   = "busybox"
          command = ["/bin/sh"]
          args    = ["-c", "rm -rf /tmp/measure/* && rm -rf /tmp/stream/*"]

          volume_mount {
            name       = "measure"
            mount_path = "/tmp/measure"
          }

          volume_mount {
            name       = "stream"
            mount_path = "/tmp/stream"
          }
        }
        container {
          image = "ghcr.io/apache/skywalking-banyandb:fb543e79a0160f65326fc6c4a9a2305b84a1d26d"
          name  = "banyand"
          args  = ["standalone"]

          liveness_probe {
            http_get {
              path = "/api/healthz"
              port = "17913"
            }

            initial_delay_seconds = 60
            period_seconds        = 30
            failure_threshold     = 5
            success_threshold     = 1
            timeout_seconds       = 20
          }

          resources {
            limits = {
              cpu    = "4"
              memory = "8G"
            }

            requests = {
              cpu    = "4"
              memory = "8G"
            }
          }

          port {
            container_port = 17912
          }

          port {
            container_port = 17913
          }

          port {
            container_port = 2121
          }

          port {
            container_port = 6060
          }

          volume_mount {
            mount_path = "/tmp/metadata"
            name       = "metadata"
          }

          volume_mount {
            mount_path = "/tmp/measure"
            name       = "measure"
          }

          volume_mount {
            mount_path = "/tmp/stream"
            name       = "stream"
          }
        }

        container {
          name    = "debug-entry"
          image   = "busybox"
          command = ["/bin/sh"]
          args    = ["-c", "while true; do ls /tmp; sleep 300s;done"]

          volume_mount {
            name       = "metadata"
            mount_path = "/tmp/metadata"
          }

          volume_mount {
            name       = "measure"
            mount_path = "/tmp/measure"
          }

          volume_mount {
            name       = "stream"
            mount_path = "/tmp/stream"
          }
        }

        volume {
          name = "metadata"

          persistent_volume_claim {
            claim_name = "banyand-metadata"
          }
        }

        volume {
          name = "measure"

          persistent_volume_claim {
            claim_name = "banyand-measure"
          }
        }

        volume {
          name = "stream"

          persistent_volume_claim {
            claim_name = "banyand-stream"
          }
        }
      }
    }
  }
  depends_on = [kubernetes_persistent_volume_claim.banyand_measure_pvc, kubernetes_persistent_volume_claim.banyand_stream_pvc, kubernetes_persistent_volume_claim.banyand_metadata_pvc]
}
