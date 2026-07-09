#!/bin/bash

set -eu
cd "$(dirname "$0")"

source ./container.ini

container_import=../volume/container-import

if [[ ! -e "$container_import" ]]; then
  echo "warning: $container_import does not exist, nothing to unlink"
  exit 0
fi

if [[ ! -L "$container_import" ]]; then
  echo "error: $container_import is not a link, can not unlink it"
  exit 1
fi

docker stop $container_name

rm $container_import

mkdir $container_import

docker start $container_name
