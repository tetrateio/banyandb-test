
provider "kubernetes" {
  config_path = variable.kube_config_path
}

provider "helm" {
  kubernetes {
    config_path = variable.kube_config_path
  }
}
