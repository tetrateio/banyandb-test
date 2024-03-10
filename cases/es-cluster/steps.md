# Elasticsearch Cluster

`cases/es-cluster` contains a minimal test case for a single Elasticsearch node.

## Provisioning EKS and Elasticsearch

```bash
# Plan the infrastructure
make -C cases/es-cluster base-plan
# Deploy the infrastructure
make -C cases/es-cluster base-deploy
# Undeploy the infrastructure
make -C cases/es-cluster base-undeploy
```

A EKS cluster named "c1" will be created. A Elasticsearch cluster will be created as well.

Install metric server

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability-1.21+.yaml
```

## Install Addons

Install the addons for the EKS cluster.

```bash
# Install the addons
make -C cases/es-cluster c1-install
# Uninstall the addons
make -C cases/es-cluster c1-uninstall
# Install the addons
make -C cases/es-cluster c2-install
# Uninstall the addons
make -C cases/es-cluster c2-uninstall
```

## Up Traffic Loads

```bash
# Wipe the existing indices in Elasticsearch
make -C cases/es-cluster c1-wipe

# Up the traffic loads
make -C cases/es-cluster c1-up
# Up the traffic loads
make -C cases/es-cluster c2-up
# Down the traffic loads
make -C cases/es-cluster c1-down
# Down the traffic loads
make -C cases/es-cluster c2-down
```

## Run the Query Tests

```bash
# Run the query tests
kubectl -n sw-system port-forward svc/skywalking-skywalking-helm-oap 12801:12800
make -C cases/es-cluster c1-query-test
kubectl -n sw-system port-forward svc/skywalking-skywalking-helm-oap 12802:12800
make -C cases/es-cluster c2-query-test
```
