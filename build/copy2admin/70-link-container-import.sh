#!/bin/bash

set -eu
cd "$(dirname "$0")"

source ./container.ini

import_source="${1:-}"
container_import=../volume/container-import

if [[ "$import_source" = "" ]]; then
  echo "usage: \$1 = import source path (folder)"
  exit 1
fi

if [[ ! -d "$import_source" ]]; then
  echo "error: $import_source folder does not exist"
  exit 2
fi

if [[ -L "$container_import" ]]; then
  echo "error: $container_import is already linked, unlink before"
  exit 3
fi

if [[ ! -d "$container_import" ]]; then
  echo "error: $container_import not folder, unable to link"
  exit 4
fi

if [[ $(ls $container_import | wc -l) != "0" ]]; then
  echo "error: $container_import not empty folder, unable to link"
  exit 5
fi


docker stop $container_name

rm -fr "$container_import"

ln -s "$import_source" "$container_import"

docker start $container_name
