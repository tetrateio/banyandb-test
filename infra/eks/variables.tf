
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
