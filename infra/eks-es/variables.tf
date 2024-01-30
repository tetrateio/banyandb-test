variable "env_name" {
  type        = string
  description = "A name to give to this env. It will be used to name resources."

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9]*$", var.env_name))
    error_message = "The 'env_name' variable must start with a letter and can only contain alphanumeric characters."
  }
}

variable "es_version" {
  type = string
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
