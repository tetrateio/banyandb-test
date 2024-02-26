resource "kubernetes_namespace" "test" {
  metadata {
    name = "test"
    labels = {
      "istio-injection" : "enabled"
    }
  }
}
locals {
  service_groups = [
    for i in range(0, var.service_group_count) : [
      for j in range(0, var.services_count) : "service${j}-group${i}-${var.kube_cluster}"
    ]
  ]
  service_group_mapping = { for i in range(0, var.services_count * var.service_group_count) : i => local.service_groups[floor(i / var.services_count)][i % var.services_count] }
}

resource "kubernetes_config_map" "sample_configmap" {
  for_each = local.service_group_mapping

  metadata {
    name      = each.value
    namespace = kubernetes_namespace.test.metadata[0].name
  }

  data = {
    "nginx.conf" = templatefile(each.key % var.services_count == var.services_count - 1 ? "templates/sample-leaf.conf" : "templates/sample.tpl.conf", {
      next_service = each.key % var.services_count == var.services_count - 1 ? "" : "service${(each.key + 1) % var.services_count}-group${floor(each.key / var.services_count)}-${var.kube_cluster}"
    })
  }

  depends_on = [
    kubernetes_namespace.test
  ]
}


resource "kubernetes_service" "sample_service" {
  for_each = local.service_group_mapping
  metadata {
    name      = each.value
    namespace = kubernetes_namespace.test.metadata[0].name
  }

  spec {
    type = "NodePort"
    port {
      port        = 9999
      target_port = 9999
      protocol    = "TCP"
    }

    selector = {
      app = each.value
    }

  }
}

resource "kubernetes_deployment" "sample_deployment" {
  for_each = local.service_group_mapping

  metadata {
    name      = each.value
    namespace = kubernetes_namespace.test.metadata[0].name
  }

  spec {
    replicas = lookup(var.services_replicas, "service${each.key % var.services_count}", var.services_default_replicas)

    selector {
      match_labels = {
        app = each.value
      }
    }

    template {
      metadata {
        labels = {
          app = each.value
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "nginx"

          port {
            container_port = 9999
          }

          volume_mount {
            name       = each.value
            mount_path = "/etc/nginx/nginx.conf"
            sub_path   = "nginx.conf"
            read_only  = true
          }
        }

        volume {
          name = each.value

          config_map {
            name = each.value
            items {
              key  = "nginx.conf"
              path = "nginx.conf"
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_service.sample_service]
}