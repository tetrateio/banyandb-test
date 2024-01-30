# banyandb-test

The test projection for verifying banyandb

## Infrastructure

`/infra` contains terraform scripts for creating the infrastructure for testing banyandb on AWS.

`/infra/eks` provisions an EKS cluster with a node group.

`/infra/eks-es` provisions an EKS cluster with a node group and an Elasticsearch cluster. The Elasticsearch cluster is the baseline to compare with banyandb.
