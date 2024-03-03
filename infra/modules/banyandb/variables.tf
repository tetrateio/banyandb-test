
variable "namespace" {
  description = "The namespace to deploy BanyanDB"
  type        = string
}

variable "enabled_deployment_mode" {
  description = "Enable pod mode"
  type        = bool
  default     = false
}