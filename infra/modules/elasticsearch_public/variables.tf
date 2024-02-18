variable "es_region" {
  type = string
}

variable "es_domain_name" {
  type = string
}

variable "es_version" {
  type = string
}

variable "es_instance_type" {
  type    = string
  default = "r6g.large.elasticsearch"
}

variable "es_instance_count" {
  type    = number
  default = 3
}

variable "es_master_enabled" {
  type    = bool
  default = true
}

variable "es_master_instance_type" {
  type    = string
  default = "m6g.large.elasticsearch"
}

variable "es_master_count" {
  type    = number
  default = 3
}

variable "es_per_instance_ebs_size" {
  type    = number
  default = 50
}

variable "es_per_instance_ebs_type" {
  type    = string
  default = "gp2"
}

variable "es_username" {
  type = string
}

variable "es_password" {
  type = string
}
