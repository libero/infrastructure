#!/bin/bash
set -e

TERRAFORM_VERSION="0.12.21"
archive="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

cd tf
wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/${archive}"
unzip -o "${archive}"
rm "${archive}"
