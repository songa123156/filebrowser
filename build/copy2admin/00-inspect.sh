#!/bin/bash
cd "$(dirname "$0")"
source ./container.ini

case "${1:-json}" in
status)
  docker inspect --format='{{.State.Status}}' "$container_name"
  ;;
health)
  docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' "$container_name"
  ;;
json|*)
  docker inspect --format='{{json .}}' "$container_name"
  ;;
esac
