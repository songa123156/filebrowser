#!/bin/bash
# show container status and ip
#set -euo pipefail
cd "$(dirname "$0")"

source ./container.ini

running=$(./00-inspect.sh "status")  # TODO status

if [[ "$running" == *running ]]
then
    health=$(docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' $container_name)
    echo "$container_name ok, health $health"
else
    echo "$container_name KO"
fi

case "$1" in
log)
    echo "####"
    echo "#### docker logs"
    echo "####"
    docker logs $container_name 2>&1 | tail -10
    echo "####"
    ;;
flog)
    docker logs -f $container_name
    ;;
esac
