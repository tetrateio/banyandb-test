# banyandb-test

The test projection for verifying banyandb

## Infrastructure

`/infra` contains terraform scripts for creating the infrastructure for testing banyandb on AWS.

`/infra/base` provisions an EKS cluster with a node group and an Elasticsearch or BanyanDB cluster.

`/infra/addons` provisions additional resources such as a Istio, OAP, and Prometheus to EKS.
