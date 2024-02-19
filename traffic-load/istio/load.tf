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
      for j in range(0, var.services_count) : "service${j}-group${i}"
    ]
  ]
}

data "template_file" "sample_configmap" {
  for_each = { for i in range(0, var.services_count * var.service_group_count) : i => local.service_groups[floor(i / var.services_count)][i % var.services_count] }
  template = file(each.key % var.services_count == var.services_count - 1 ? "templates/sample-conf-leaf.tpl.yaml" : "templates/sample-conf.tpl.yaml")
  vars = {
    configmap_name = each.value
    namespace      = kubernetes_namespace.test.metadata[0].name
    next_service   = each.key % var.services_count == var.services_count - 1 ? "" : "service${(each.key + 1) % var.services_count}-group${floor(each.key / var.services_count)}"
  }
}

data "template_file" "sample_deployment" {
  for_each = { for i in range(0, var.services_count * var.service_group_count) : i => local.service_groups[floor(i / var.services_count)][i % var.services_count] }
  template = file("templates/sample-deployment.tpl.yaml")
  vars = {
    service_name = each.value
    namespace    = kubernetes_namespace.test.metadata[0].name
    configmap    = each.value
    replicas     = lookup(var.services_replicas, "service${each.key % var.services_count}", var.services_default_replicas)
  }
}

data "template_file" "sample_service" {
  for_each = { for i in range(0, var.services_count * var.service_group_count) : i => local.service_groups[floor(i / var.services_count)][i % var.services_count] }
  template = file("templates/sample-service.tpl.yaml")
  vars = {
    service_name = each.value
    namespace    = kubernetes_namespace.test.metadata[0].name
  }
}

resource "kubectl_manifest" "sample_service" {
  for_each  = data.template_file.sample_service
  yaml_body = each.value.rendered
}

resource "kubectl_manifest" "sample_configmap" {
  for_each  = data.template_file.sample_configmap
  yaml_body = each.value.rendered
}

resource "kubectl_manifest" "sample_deployment" {
  depends_on = [kubectl_manifest.sample_service]
  for_each   = data.template_file.sample_deployment
  yaml_body  = each.value.rendered
}
