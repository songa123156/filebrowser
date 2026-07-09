#!/bin/bash
# start container
set -euo pipefail
cd "$(dirname "$0")"

source ./container.ini

docker start $container_name
./10-status.sh
