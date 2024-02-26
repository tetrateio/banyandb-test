#!/usr/bin/env bash

set -eu -o pipefail

filename=${1:-vars.json}

echo "var-file: $filename"
# Refresh STS token
eval "$( command rapture shell-init )"
rapture assume tetrate-skywalking-dev/admin
rapture refresh

export KUBECONFIG=~/.kube/config-$(jq -r '.kube_cluster' $filename).yaml

kubectl -n sw-system scale --replicas 0 deployment skywalking-skywalking-helm-oap

es_host=$(jq -r '.elasticsearch_host' $filename)
es_user=$(jq -r '.elasticsearch_user' $filename)
es_pass=$(jq -r '.elasticsearch_password' $filename)

for tmpl in $(curl -u "$es_user:$es_pass" -sS https://$es_host/_cat/templates | \
  egrep "sw" | \
  awk '{print $1}'); do echo "$tmpl: "; curl -u "$es_user:$es_pass" -sS https://$es_host/_index_template/$tmpl -XDELETE; echo "\n";
done
for idx in $(curl -u "$es_user:$es_pass" https://$es_host/_cat/indices | \
  egrep "sw" | \
  awk '{print $3}'); do echo "$idx: "; curl -u "$es_user:$es_pass" https://$es_host/$idx -XDELETE; echo "\n";
done

kubectl -n sw-system scale --replicas 1 deployment skywalking-skywalking-helm-oap
