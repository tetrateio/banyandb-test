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

## Services

variable "service_group_count" {
  description = "The number of service groups"
  type        = number
  default     = 4
}

variable "services_count" {
  default = 4
}

variable "services_default_replicas" {
  default = 8
}

variable "services_replicas" {
  type    = map(number)
  default = {}
}

## k6
variable "k6_parallelism" {
  default = 4
}

variable "k6_duration_initial" {
  default = "1m"
}

variable "k6_duration_target" {
  default = "1h"
}

variable "k6_vus_initial" {
  default = 4
}

variable "k6_vus_target" {
  default = 32
}
