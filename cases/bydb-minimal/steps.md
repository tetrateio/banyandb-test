# Minimal single Elasticsearch node

`cases/bydb-minimal` contains a minimal test case for a single Elasticsearch node.

## Provisioning EKS and BanyanDB

```bash
# Plan the infrastructure
make -C cases/bydb-minimal base-plan
# Deploy the infrastructure
make -C cases/bydb-minimal base-deploy
# Undeploy the infrastructure
make -C cases/bydb-minimal base-undeploy
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
make -C cases/bydb-minimal c1-install
# Uninstall the addons
make -C cases/bydb-minimal c1-uninstall
```

## Up Traffic Loads

```bash
# Restart banyandb to clean up all data on the disk
make -C cases/bydb-minimal c1-clean

# Up the traffic loads
make -C cases/bydb-minimal c1-up
# Down the traffic loads
make -C cases/bydb-minimal c1-down
```

## Run the Query Tests

```bash
# Run the query tests
kubectl -n sw-system port-forward svc/skywalking-skywalking-helm-oap 12800:12800
make -C cases/bydb-minimal query-test
```
