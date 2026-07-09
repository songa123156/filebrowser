#!/bin/bash
# stop container
set -euo pipefail
cd "$(dirname "$0")"

source ./container.ini

if [[ "$#" = 0 ]]; then
	docker exec -it $container_name bash
else
	docker exec -it $container_name bash -c "$*"
fi
