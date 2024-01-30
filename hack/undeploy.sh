#!/usr/bin/env bash

set -eu -o pipefail

# Refresh STS token
eval "$( command rapture shell-init )"
rapture assume tetrate-test/admin
rapture refresh

# Do the Terraform undeploy
terraform destroy -auto-approve -var-file vars.json
