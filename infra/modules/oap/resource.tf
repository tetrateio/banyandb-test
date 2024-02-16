resource "kubernetes_namespace" "sw_system" {
  metadata {
    name = "sw-system"
  }
}

data "template_file" "helm_values_template" {
  template = file("../templates/oap-values.tpl")
  vars = {
    storage_type = var.storage_type
  }
}

resource "local_file" "helm_values" {
  filename = "${path.module}/out/oap-values.yaml"
  content  = data.template_file.helm_values_template.rendered
}

resource "helm_release" "skywalking" {
  name      = "skywalking"
  chart     = "oci://ghcr.io/apache/skywalking-kubernetes/skywalking-helm"
  version   = "0.0.0-aa2c3e195f9c2d49549bea7ae592166e7b496da6"
  namespace = kubernetes_namespace.sw_system.metadata[0].name
  values    = [data.template_file.helm_values_template.rendered]
}
