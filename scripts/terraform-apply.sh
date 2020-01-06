#!/bin/bash
set -e

if [ "$#" -eq 1 ]; then
    echo "Usage: scripts/terraform-apply.sh ENVIRONMENT"
    echo "Example: scripts/terraform-apply.sh franklin"
    exit 1
fi

environment="${1}"

cd "envs/${environment}"
rm -rf .terraform
../../terraform init \
    --backend-config="key=${environment}/terraform.tfstate" \
    -input=false
../../terraform apply "/tmp/${environment}.plan"
