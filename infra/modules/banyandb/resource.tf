resource "kubernetes_namespace" "sw_system" {
  metadata {
    name = "sw-system"
  }
}
