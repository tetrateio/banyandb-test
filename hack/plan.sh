#!/usr/bin/env bash

set -eu -o pipefail

filename=${1:-vars.json}

echo "var-file: $filename"

terraform init
terraform validate

terraform plan -var-file $filename
