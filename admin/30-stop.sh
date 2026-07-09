#!/bin/bash
# stop container
set -euo pipefail
cd "$(dirname "$0")"

source ./container.ini
docker stop $container_name
./10-status.sh
