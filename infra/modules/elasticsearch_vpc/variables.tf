# Copyright (c) Tetrate, Inc 2024 All Rights Reserved.

variable "es_region" {
  type = string
}

variable "es_domain_name" {
  type = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9]*$", var.es_domain_name))
    error_message = "The 'es_domain_name' variable must start with a letter and can only contain alphanumeric characters."
  }
}

variable "es_vpc_id" {
  type = string
}

variable "es_vpc_cidr" {
  type = string
}

variable "es_vpc_subnet_ids" {
  type = list(string)
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
