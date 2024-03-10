
variable "region" {
  type = string
}

variable "cluster_names" {
  type    = list(string)
  default = ["central"]
}


# VPC
variable "vpc_name" {
  type    = string
  default = "eks-test-vpc"
}

# EKS
variable "worker_instance_types" {
  type    = list(string)
  default = ["t3.large"]
}

variable "node_pool_desired_size" {
  type    = number
  default = 3
}
variable "node_pool_max_size" {
  type    = number
  default = 7
}
variable "node_pool_min_size" {
  type    = number
  default = 3
}
variable "eks_k8s_version" {
  type    = string
  default = null
}

# Where to put generated kubeconfig for a newly created cluster
# Updated on each terraform apply run
variable "kube_config_output_dir" {
  type    = string
  default = "~/.kube"
}

# Elasticsearch
variable "es_enabled" {
  type = bool
}

variable "es_version" {
  type    = string
  default = "OpenSearch_2.11"
}

variable "es_username" {
  type    = string
  default = "not-elastic"
}

variable "es_password" {
  type    = string
  default = "N0t-3l4st!c"
}

variable "es_master_enabled" {
  type    = bool
  default = true
}

variable "es_worker_instance_count" {
  type    = number
  default = 3
}

variable "es_worker_instance_type" {
  type    = string
  default = "r6g.large.elasticsearch"
}
