
module "vpc" {
  source = "../lib/networking"

  region             = var.region
  vpc_name           = var.vpc_name
  vpc_cidr           = "10.0.0.0/16"
  vpc_secondary_cidr = "10.1.0.0/16"
  cluster_names      = var.cluster_names
}

module "eks-management" {
  source = "../modules/eks_cluster"

  region                 = var.region
  cluster_names          = var.cluster_names
  worker_instance_types  = var.worker_instance_types
  node_pool_min_size     = var.node_pool_min_size
  node_pool_max_size     = var.node_pool_max_size
  node_pool_desired_size = var.node_pool_desired_size
  subnet_ids             = module.vpc.private_subnet_ids_az
  eks_k8s_version        = var.eks_k8s_version
}

data "template_file" "kubeconfig" {
  for_each = toset(var.cluster_names)

  template = file("../templates/kubeconfig.tpl")
  vars = {
    ca_data  = module.eks-management.clusters[each.key].certificate_authority.0.data
    endpoint = module.eks-management.clusters[each.key].endpoint
    name     = each.value
    region   = var.region
  }
}
resource "local_file" "kubeconfig_files" {
  for_each = toset(var.cluster_names)
  content  = data.template_file.kubeconfig[each.value].rendered
  filename = "${pathexpand(var.kube_config_output_dir)}/config-${each.value}.yaml"
  depends_on = [
    module.eks-management.clusters
  ]
}

module "es" {
  source = "../modules/elasticsearch_public"

  es_region      = var.region
  es_domain_name = "es-${var.region}-test}"
  es_version     = var.es_version
  es_username    = var.es_username
  es_password    = var.es_password
}


module "istio" {
  for_each         = var.enable_istio ? toset(var.cluster_names) : toset([])
  source           = "../modules/istio"
  kube_config_path = "${pathexpand(var.kube_config_output_dir)}/config-${each.value}.yaml"
  oap_endpoint     = "${module.oap.helm_release[each.value].skywalking.name}-skywalking-helm-oap.${module.oap.helm_release[each.value].skywalking.namespace}:11800"

  depends_on = [resource.local_file.kubeconfig_files]
}

module "oap" {
  for_each               = toset(var.cluster_names)
  source                 = "../modules/oap"
  kube_config_path       = "${pathexpand(var.kube_config_output_dir)}/config-${each.value}.yaml"
  storage_type           = "elasticsearch"
  elasticsearch_host     = module.es.es_address
  elasticsearch_user     = module.es.es_username
  elasticsearch_password = module.es.es_password

  depends_on = [resource.local_file.kubeconfig_files, module.mp_es.es_address]
}

output "instructions" {
  value = <<EOT

  ###
  ##
  #

  To set the provisioned cluster(s) as your active context, set
  KUBECONFIG variable to the generated configuration file:

  %{for cluster in var.cluster_names~}
  ${pathexpand(var.kube_config_output_dir)}/config-${cluster}.yaml
  %{endfor~}

  EOT

}