#!/usr/bin/env bash

set -eu -o pipefail

filename=${1:-vars.json}

echo "var-file: $filename"

# Refresh STS token
eval "$( command rapture shell-init )"
rapture assume tetrate-skywalking-dev/admin
rapture refresh

terraform init
terraform validate

terraform plan -var-file $filename
