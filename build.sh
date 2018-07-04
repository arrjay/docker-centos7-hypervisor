#!/usr/bin/env bash

set -ex

#docker pull "${DOCKER_SINK}/xenial-bootable"
docker tag  "${DOCKER_SINK}/centos7-bootable" "centos7-bootable"

set -u

cd docker && docker build -t "build/centos7-hypervisor" .
