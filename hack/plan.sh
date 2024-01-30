#!/usr/bin/env bash

set -eu -o pipefail

terraform init
terraform validate

terraform plan -var-file vars.json
