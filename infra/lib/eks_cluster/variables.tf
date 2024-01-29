
variable "region" {
  type = string
}

variable "cluster_names" {
  type = list(string)
}

variable "worker_instance_types" {
  type = list(string)
}

variable "node_pool_desired_size" {
  type = number
}

variable "node_pool_max_size" {
  type = number
}

variable "node_pool_min_size" {
  type = number
}

variable "subnet_ids" {
  type = map(any)
}

variable "eks_k8s_version" {
  type    = string
  default = null
}
