
variable "cluster_names" {
  type = list(string)
}

variable "region" {
  type = string
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

# Istio

variable "enable_istio" {
  description = "Enable or disable the istio module"
  type        = bool
  default     = true
}

# OAP
