#!/usr/bin/env bash

set -eu -o pipefail

filename=${1:-vars.json}

# Refresh STS token
eval "$( command rapture shell-init )"
rapture assume tetrate-skywalking-dev/admin
rapture refresh

# Do the Terraform undeploy
terraform destroy -auto-approve -var-file $filename
