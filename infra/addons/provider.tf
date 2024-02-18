
provider "kubernetes" {
  config_path = "${pathexpand(var.kube_config_output_dir)}/config-${var.kube_cluster}.yaml"
}

provider "helm" {
  kubernetes {
    config_path = "${pathexpand(var.kube_config_output_dir)}/config-${var.kube_cluster}.yaml"
  }
}
