#!/bin/bash
# build and run container
set -euo pipefail

source ./build.ini

# create container
docker container rm -f $ctn_name 2>/dev/null

echo "re-create folder $ctn_admin"
rm -fr "$ctn_admin"
mkdir -p "$ctn_admin"

echo "prepare folder $ctn_volume"
mkdir -p "$ctn_volume"

for map in ${volume_map[@]}
do
  folder="$(echo $map | cut -d":" -f1)"
  echo "re-create mapped folder $folder"
  mkdir -p "$folder"
done

cp -rp copy2admin/*.* $ctn_admin
chmod +x $ctn_admin/*.sh
for item in copy2dock/*; do
  [ -e "$item" ] || continue
  if [[ "$(basename "$item")" == "project_here" ]]; then
    continue
  fi
  cp -r "$item" "$ctn_volume/"
done
find $ctn_volume -type f -name "*.sh" -exec chmod +x {} \;

if ((${#envvar_map[@]})); then
  envvar_map="$(printf -- "-e %s " "${envvar_map[@]}")"
else
  envvar_map=""
fi

if ((${#volume_map[@]})); then
  volume_map="$(printf -- "-v %s " "${volume_map[@]}")"
else
  volume_map=""
fi

if ((${#port_map[@]})); then
  port_map="$(printf -- "-p %s " "${port_map[@]}")"
else
  port_map=""
fi

docker run -d \
  --name $ctn_name \
  -h $ctn_name \
  $envvar_map \
  $volume_map \
  $port_map \
  $ctn_img

CONTAINER_NAME="$ctn_name"
TIMEOUT=300  # seconds

echo "Waiting for healthy container $CONTAINER_NAME (timeout: $TIMEOUT seconds)"

ready=0
for i in $(seq 1 "$TIMEOUT"); do
    health="$(docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' "$CONTAINER_NAME")"
    if [[ "$health" == "healthy" || "$health" == "running" ]]; then
        echo "container status: $health"
        ready=1
        break
    fi
    sleep 1
done

if [[ "$ready" != "1" ]]; then
    echo "Timeout: container did not become healthy within $TIMEOUT seconds."
    docker logs "$CONTAINER_NAME" 2>&1 | tail -50
    exit 1
fi

echo "container created and running"




