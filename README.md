# banyandb-test

The test projection for verifying banyandb

## Infrastructure

`/infra` contains terraform scripts for creating the infrastructure for testing banyandb on AWS.

`/infra/base` provisions an EKS cluster with a node group and an Elasticsearch or BanyanDB cluster.

`/infra/addons` provisions additional resources such as a Istio, OAP, and Prometheus to EKS.

## Test Cases

### Test Case 1: Minimal single Elasticsearch node

`cases/es-minimal` contains a minimal test case for a single Elasticsearch node.

### Test Case 2: Minimal single BanyanDB node

`cases/bydb-minimal` contains a minimal test case for a single BanyanDB node.

### Test Case 3: Elasticsearch cluster

`cases/es-cluster` contains a test case for an Elasticsearch cluster.
