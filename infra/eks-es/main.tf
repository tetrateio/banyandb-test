
module "vpc" {
  source = "../lib/networking"

  region             = var.region
  vpc_name           = var.vpc_name
  vpc_cidr           = "10.0.0.0/16"
  vpc_secondary_cidr = "10.1.0.0/16"
  cluster_names      = ["${var.env_name}-eks"]
}

module "es" {
  source = "../lib/elasticsearch_vpc"

  es_region         = var.region
  es_vpc_id         = module.vpc.vpc_id
  es_vpc_cidr       = module.vpc.vpc_cidr
  es_vpc_subnet_ids = module.vpc.private_subnet_ids
  es_domain_name    = var.env_name
  es_version        = var.es_version
}
