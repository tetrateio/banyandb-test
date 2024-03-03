
resource "kubernetes_storage_class" "st1" {
  metadata {
    name = "st1"
  }
  storage_provisioner = "kubernetes.io/aws-ebs"
  parameters = {
    type   = "st1"
    fsType = "ext4"
  }
}

resource "kubernetes_persistent_volume_claim" "banyand_metadata_pvc" {
  metadata {
    name      = "banyand-metadata"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    volume_mode        = "Filesystem"
    storage_class_name = "gp2"
  }
  wait_until_bound = false
}

resource "kubernetes_persistent_volume_claim" "banyand_measure_pvc" {
  metadata {
    name      = "banyand-measure"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "125Gi"
      }
    }
    volume_mode        = "Filesystem"
    storage_class_name = "st1"
  }
  depends_on       = [kubernetes_storage_class.st1]
  wait_until_bound = false
}

resource "kubernetes_persistent_volume_claim" "banyand_stream_pvc" {
  metadata {
    name      = "banyand-stream"
    namespace = var.namespace
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "125Gi"
      }
    }
    volume_mode        = "Filesystem"
    storage_class_name = "st1"
  }
  depends_on       = [kubernetes_storage_class.st1]
  wait_until_bound = false
}