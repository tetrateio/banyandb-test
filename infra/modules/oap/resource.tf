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
  chart     = "oci://ghcr.io/apache/skywalking-kubernetes/skywalking-helm"
  version   = "0.0.0-aa2c3e195f9c2d49549bea7ae592166e7b496da6"
  namespace = kubernetes_namespace.sw_system.metadata[0].name
  values    = [local.helm_values]
}

output "oap_endpoint" {
  value = "${helm_release.skywalking.name}-skywalking-helm-oap.${kubernetes_namespace.sw_system.metadata[0].name}:11800"
}
