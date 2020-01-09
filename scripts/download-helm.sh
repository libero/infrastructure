#!/bin/bash
set -e

HELM_VERSION="${HELM_VERSION:-3.0.1}"
archive="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

wget "https://get.helm.sh/${archive}"
tar xvzf "${archive}" --strip-components=1 linux-amd64/helm
rm "${archive}"
