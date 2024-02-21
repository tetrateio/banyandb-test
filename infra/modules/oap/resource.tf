resource "kubernetes_namespace" "sw_system" {
  metadata {
    name = "sw-system"
  }
}

locals {
  helm_values = templatefile("../templates/oap-values.tpl", {
    storage_type           = var.storage_type
    elasticsearch_host     = var.elasticsearch_host
    elasticsearch_user     = var.elasticsearch_user
    elasticsearch_password = var.elasticsearch_password
  })
}

resource "local_file" "helm_values" {
  filename = "${path.module}/out/oap-values.yaml"
  content  = local.helm_values
}

resource "helm_release" "skywalking" {
  name      = "skywalking"
  chart     = "oci://registry-1.docker.io/apache/skywalking-helm"
  version   = "4.5.0"
  namespace = kubernetes_namespace.sw_system.metadata[0].name
  values    = [local.helm_values]
  wait      = false
}

output "oap_endpoint" {
  value = "${helm_release.skywalking.name}-skywalking-helm-oap.${kubernetes_namespace.sw_system.metadata[0].name}:11800"
}
