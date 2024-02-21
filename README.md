# banyandb-test

The test projection for verifying banyandb

## Infrastructure

`/infra` contains terraform scripts for creating the infrastructure for testing banyandb on AWS.

`/infra/base` provisions an EKS cluster with a node group and an Elasticsearch or BanyanDB cluster.

`/infra/addons` provisions additional resources such as a Istio, OAP, and Prometheus to EKS.

## Test Cases

### Test Case 1: Minimal single Elasticsearch node

`cases/es-minimal` contains a minimal test case for a single Elasticsearch node.

#### Provisioning EKS and Elasticsearch

```bash
# Plan the infrastructure
make -C cases/es-minimal base-plan
# Deploy the infrastructure
make -C cases/es-minimal base-deploy
# Undeploy the infrastructure
make -C cases/es-minimal base-undeploy
```

#### Deploy Addons

```bash
# Plan the addons
make -C cases/es-minimal addons-plan
# Deploy the addons
make -C cases/es-minimal addons-deploy
# Undeploy the addons
make -C cases/es-minimal addons-undeploy
```