---
elasticsearch:
  enabled: false
  config:
    host: ${elasticsearch_host}
    port:
      http: 443
    user: ${elasticsearch_user}
    password: ${elasticsearch_password}

oap:
  replicas: 1
  image:
    repository: ghcr.io/apache/skywalking/oap
    tag: a471b85ac2648d4a93ec4e853e4ee101324cf1bd
  storageType: ${storage_type}
  env:
    SW_STORAGE_ES_HTTP_PROTOCOL: https
    SW_TELEMETRY: prometheus
    SW_ENVOY_METRIC_ALS_HTTP_ANALYSIS: mx-mesh,k8s-mesh
    SW_ENVOY_METRIC_ALS_TCP_ANALYSIS: mx-mesh,k8s-mesh
    SW_STORAGE_BANYANDB_HOST: ${banyandb_host}
  envoy:
    als:
      enabled: true
  ports:
    http-monitoring: 1234
  javaOpts: -Xmx16g -Xms16g
  resources:
    requests:
      cpu: 10
      memory: 18Gi
    limit:
      cpu: 12
      memory: 20Gi

ui:
  image:
    repository: ghcr.io/apache/skywalking/ui
    tag: a471b85ac2648d4a93ec4e853e4ee101324cf1bd
