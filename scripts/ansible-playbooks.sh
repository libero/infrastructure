#!/bin/bash
set -e

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 IP KEY"
    echo "Example: $0 127.0.0.1 single-node--unstable.key"
    exit 1
fi

ip="$1"
key="$2"

ANSIBLE_HOST_KEY_CHECKING=False \
    ansible-playbook \
    -i "${ip}", \
    --key-file "${key}" \
    ../playbooks/boot.playbook \
    ../playbooks/docker.playbook \
    ../playbooks/newrelic-infrastructure.playbook
