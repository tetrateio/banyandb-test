resource "kubernetes_manifest" "banyand_deployment" {
  manifest = {
    apiVersion = "apps/v1"
    kind       = "Deployment"
    metadata = {
      name      = "banyand"
      namespace = kubernetes_namespace.sw_system.metadata[0].name
    }
    spec = {
      replicas = 1
      selector = {
        matchLabels = {
          app = "banyand"
        }
      }
      strategy = {
        type = "Recreate"
      }
      template = {
        metadata = {
          labels = {
            app = "banyand"
          }
        }
        spec = {
          initContainers = [
            {
              image   = "busybox"
              command = ["/bin/sh"]
              args    = ["-c", "rm -rf /tmp/measure/* && rm -rf /tmp/stream/*"]
              name    = "cleanup"
              volumeMounts = [
                {
                  name      = "measure"
                  mountPath = "/tmp/measure"
                },
                {
                  name      = "stream"
                  mountPath = "/tmp/stream"
                }
              ]
            }
          ]
          containers = [
            {
              name            = "banyand"
              image           = "ghcr.io/apache/skywalking-banyandb:fb543e79a0160f65326fc6c4a9a2305b84a1d26d"
              args            = ["standalone", "--measure-flush-timeout=10s", "--logging-level=info"]
              imagePullPolicy = "Always"
              livenessProbe = {
                failureThreshold = 5
                httpGet = {
                  path   = "/api/healthz"
                  port   = 17913
                  scheme = "HTTP"
                }
                initialDelaySeconds = 20
                periodSeconds       = 10
                successThreshold    = 1
                timeoutSeconds      = 10
              }
              resources = {
                limits = {
                  memory = "8G"
                  cpu    = "2"
                }
                requests = {
                  memory = "20G"
                  cpu    = "14"
                }
              }
              ports = [
                {
                  containerPort = 17912
                },
                {
                  containerPort = 17913
                },
                {
                  containerPort = 2121
                },
                {
                  containerPort = 6060
                }
              ]
              volumeMounts = [
                {
                  name      = "metadata"
                  mountPath = "/tmp/metadata"
                },
                {
                  name      = "measure"
                  mountPath = "/tmp/measure"
                },
                {
                  name      = "stream"
                  mountPath = "/tmp/stream"
                }
              ]
            },
            {
              image   = "busybox"
              command = ["/bin/sh"]
              args    = ["-c", "while true; do ls /tmp; sleep 300s;done"]
              name    = "debug-entry"
              volumeMounts = [
                {
                  name      = "metadata"
                  mountPath = "/tmp/metadata"
                },
                {
                  name      = "measure"
                  mountPath = "/tmp/measure"
                },
                {
                  name      = "stream"
                  mountPath = "/tmp/stream"
                }
              ]
            }
          ]
          nodeSelector = {
            group = "banyandb"
          }
          tolerations = [
            {
              effect   = "NoSchedule"
              key      = "group"
              operator = "Equal"
              value    = "banyandb"
            }
          ]
          volumes = [
            {
              name = "metadata"
              persistentVolumeClaim = {
                claimName = "banyand-metadata"
              }
            },
            {
              name = "measure"
              persistentVolumeClaim = {
                claimName = "banyand-measure"
              }
            },
            {
              name = "stream"
              persistentVolumeClaim = {
                claimName = "banyand-stream"
              }
            }
          ]
        }
      }
    }
  }
}
