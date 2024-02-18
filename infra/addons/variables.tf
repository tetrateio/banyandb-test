
variable "region" {
  type = string
}

variable "kube_config_output_dir" {
  type    = string
  default = "~/.kube"
}

variable "kube_cluster" {
  type = string
}

# Istio

variable "enable_istio" {
  description = "Enable or disable the istio module"
  type        = bool
  default     = true
}

# OAP

variable "storage_type" {
  type    = string
  default = "banyandb"
}

variable "elasticsearch_host" {
  type    = string
  default = ""
}

variable "elasticsearch_user" {
  type    = string
  default = ""
}

variable "elasticsearch_password" {
  type    = string
  default = ""
}
