data "local_file" "istio_scenario" {
  filename = "templates/istio.js"
}

resource "kubernetes_config_map" "k6_test_script" {
  metadata {
    name      = "k6-istio"
    namespace = kubernetes_namespace.test.metadata[0].name
  }
  data = {
    "istio.js" = data.local_file.istio_scenario.content
  }
}
locals {
  job_templates = {
    for i in range(0, var.service_group_count) :
    "group${i}_job" => templatefile("templates/k6-test-job.tpl.yaml", {
      NAME             = "k6-test-group${i}"
      NAMESPACE        = kubernetes_namespace.test.metadata[0].name
      CONFIG_MAP_NAME  = kubernetes_config_map.k6_test_script.metadata.0.name
      PARALLELISM      = var.k6_parallelism
      DURATION_INITIAL = var.k6_duration_initial
      DURATION_TARGET  = var.k6_duration_target
      INITIAL_VUS      = var.k6_vus_initial
      TARGET_VUS       = var.k6_vus_target
      API_URL          = "http://service0-group${i}.test:9999"
    })
  }
}

resource "kubectl_manifest" "k6_test" {
  for_each  = local.job_templates
  yaml_body = each.value
}
