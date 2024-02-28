provider "kubernetes-alpha" {
  config_path = "~/.kube/config" // replace with your kubeconfig path
}

resource "kubernetes_manifest" "banyand_metadata_pvc" {
  manifest = {
    apiVersion = "v1"
    kind       = "PersistentVolumeClaim"
    metadata = {
      name      = "banyand-metadata"
      namespace = kubernetes_namespace.sw_system.metadata[0].name
    }
    spec = {
      resources = {
        requests = {
          storage = "5Gi"
        }
      }
      volumeMode       = "Filesystem"
      accessModes      = ["ReadWriteOnce"]
      storageClassName = "gp2"
    }
  }
}

resource "kubernetes_manifest" "banyand_measure_pvc" {
  manifest = {
    apiVersion = "v1"
    kind       = "PersistentVolumeClaim"
    metadata = {
      name = "banyand-measure"
    }
    spec = {
      resources = {
        requests = {
          storage = "100Gi"
        }
      }
      volumeMode       = "Filesystem"
      accessModes      = ["ReadWriteOnce"]
      storageClassName = "st1"
    }
  }
}

resource "kubernetes_manifest" "banyand_stream_pvc" {
  manifest = {
    apiVersion = "v1"
    kind       = "PersistentVolumeClaim"
    metadata = {
      name = "banyand-stream"
    }
    spec = {
      resources = {
        requests = {
          storage = "100Gi"
        }
      }
      volumeMode       = "Filesystem"
      accessModes      = ["ReadWriteOnce"]
      storageClassName = "st1"
    }
  }
}