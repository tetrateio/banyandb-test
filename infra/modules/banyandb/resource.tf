
output "banyandb_targets" {
  value = "${kubernetes_service.banyand_service.metadata.0.name}:17912"
}