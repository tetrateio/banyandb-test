
module "vpc" {
  source = "../modules/networking"

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

locals {
  kubeconfig = { for k in toset(var.cluster_names) : k => templatefile("../templates/kubeconfig.tpl", {
    ca_data  = module.eks-management.clusters[k].certificate_authority.0.data
    endpoint = module.eks-management.clusters[k].endpoint
    name     = k
    region   = var.region
  }) }
}

resource "local_file" "kubeconfig_files" {
  for_each = toset(var.cluster_names)
  content  = local.kubeconfig[each.value]
  filename = "${pathexpand(var.kube_config_output_dir)}/config-${each.value}.yaml"
  depends_on = [
    module.eks-management.clusters
  ]
}

module "es" {
  count  = var.es_enabled ? 1 : 0
  source = "../modules/elasticsearch_public"

  es_region         = var.region
  es_domain_name    = "es-${var.region}-test"
  es_version        = var.es_version
  es_username       = var.es_username
  es_password       = var.es_password
  es_master_enabled = var.es_master_enabled
  es_instance_count = var.es_worker_instance_count
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

output "elasticsearch_info" {
  description = "Information to connect to Elasticsearch"
  value = {
    es_endpoint = length(module.es) > 0 ? module.es[0].es_address : null
    es_username = var.es_username
    es_password = var.es_password
  }
}