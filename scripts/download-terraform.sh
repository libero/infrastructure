#!/bin/bash
set -e

TERRAFORM_VERSION="${TERRAFORM_VERSION:-0.11.14}"
archive="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

cd tf
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${archive}"
unzip -o "${archive}"
rm "${archive}"
