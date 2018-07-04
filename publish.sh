#!/usr/bin/env bash

ts=$(date +%s)

for img in $(docker images "build/*" --format "{{.Repository}}:{{.Tag}}") ; do
  docker tag "${img}" "${DOCKER_SINK}/centos7-hypervisor:latest"
  docker tag "${img}" "${DOCKER_SINK}/centos7-hypervisor:latest.${ts}"
  [ "${NOPUSH}" ] || {
    docker push "${DOCKER_SINK}/centos7-hypervisor:latest"
    docker push "${DOCKER_SINK}/centos7-hypervisor:latest.${ts}"
  }
done

