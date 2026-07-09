#!/bin/bash

set -eu
cd "$(dirname "$0")"

source ./container.ini

export_target="${1:-}"
container_export=../volume/container-export

if [[ "$export_target" = "" ]]; then
  echo "usage: \$1 = export target path (folder)"
  exit 1
fi

if [[ ! -d "$export_target" ]]; then
  echo "error: $export_target folder does not exist"
  exit 2
fi

if [[ -L "$container_export" ]]; then
  echo "error: $container_export is already linked, unlink before"
  exit 3
fi

if [[ ! -d "$container_export" ]]; then
  echo "error: $container_export not folder, unable to link"
  exit 4
fi

if [[ $(ls $container_export | wc -l) != "0" ]]; then
  echo "error: $container_export not empty folder, unable to link"
  exit 5
fi


docker stop $container_name

rm -fr "$container_export"

ln -s "$export_target" "$container_export"

docker start $container_name
