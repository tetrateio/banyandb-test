elasticsearch:
  enabled : false
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
    tag: a688500fb45973d3dec369b5eecf843489f56094
  storageType: ${storage_type}
  env:
    SW_TELEMETRY: prometheus
    SW_ENVOY_METRIC_ALS_HTTP_ANALYSIS: mx-mesh,k8s-mesh
    SW_ENVOY_METRIC_ALS_TCP_ANALYSIS: mx-mesh,k8s-mesh
  envoy:
    als:
      enabled: true
  ports:
    http-monitoring: 1234

ui:
  image:
    repository: ghcr.io/apache/skywalking/ui
    tag: a688500fb45973d3dec369b5eecf843489f56094