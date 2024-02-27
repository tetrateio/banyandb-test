# Minimal single Elasticsearch node

`cases/es-minimal` contains a minimal test case for a single Elasticsearch node.

## Provisioning EKS and Elasticsearch

```bash
# Plan the infrastructure
make -C cases/es-minimal base-plan
# Deploy the infrastructure
make -C cases/es-minimal base-deploy
# Undeploy the infrastructure
make -C cases/es-minimal base-undeploy
```

A EKS cluster named "c1" will be created. A Elasticsearch cluster will be created as well.

## Install Addons

Install the addons for the EKS cluster.

```bash
# Install the addons
make -C cases/es-minimal c1-install
# Uninstall the addons
make -C cases/es-minimal c1-uninstall
```

## Up Traffic Loads

```bash
# Wipe the existing indices in Elasticsearch
make -C cases/es-minimal c1-wipe

# Up the traffic loads
make -C cases/es-minimal c1-up
# Down the traffic loads
make -C cases/es-minimal c1-down
```

## Run the Query Tests

```bash
# Run the query tests
kubectl -n sw-system port-forward svc/skywalking-skywalking-helm-oap 12800:12800
make -C cases/es-minimal query-test
```
