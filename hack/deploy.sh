#!/usr/bin/env bash

set -eu -o pipefail

filename=${1:-vars.json}

# Do the Terraform deploy
# Retry for delays in namespace and CRD creation
max_retry=10
counter=1

# Terraform init to download reqiured plugins
terraform init

# Refresh STS token
eval "$( command rapture shell-init )"
rapture assume tetrate-skywalking-dev/admin
rapture refresh

until terraform apply -auto-approve -var-file $filename
do
   sleep 10
   echo "Attempt #$counter"; date
   [[ $counter -eq $max_retry ]] && echo "Failed to create Terraform environment after ${max_retry} attempts" && exit 1
   printf "\n\n"
   ((counter++))
done
