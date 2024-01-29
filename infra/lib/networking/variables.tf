variable "region" {
  type = string
}

variable "vpc_name" {
  type = string
}
variable "vpc_cidr" {
  type = string
}
variable "vpc_secondary_cidr" {
  type = string
}

# Used exclusively for resource tagging.
variable "cluster_names" {
  type = list(string)
}
