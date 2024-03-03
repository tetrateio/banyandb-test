#!/usr/bin/env bash

set -eu -o pipefail

filename=${1:-vars.json}

echo "var-file: $filename"
# Refresh STS token
eval "$( command rapture shell-init )"
rapture assume tetrate-skywalking-dev/admin
rapture refresh

export KUBECONFIG=~/.kube/config-${TF_VAR_kube_cluster}.yaml

kubectl -n sw-system scale --replicas 0 deployment skywalking-skywalking-helm-oap

kubectl -n sw-system scale --replicas 0 deployment banyand

kubectl -n sw-system scale --replicas 1 deployment banyand

kubectl -n sw-system scale --replicas 1 deployment skywalking-skywalking-helm-oap
