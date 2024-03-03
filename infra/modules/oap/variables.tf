
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

variable "banyandb_targets" {
  type    = string
  default = ""
}
