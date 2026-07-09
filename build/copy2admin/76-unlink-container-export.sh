#!/bin/bash

set -eu
cd "$(dirname "$0")"

source ./container.ini

container_export=../volume/container-export

if [[ ! -e "$container_export" ]]; then
  echo "warning: $container_export does not exist, nothing to unlink"
  exit 0
fi

if [[ ! -L "$container_export" ]]; then
  echo "error: $container_export is not a link, can not unlink it"
  exit 1
fi

docker stop $container_name

rm $container_export

mkdir $container_export

docker start $container_name
