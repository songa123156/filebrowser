#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"

./30-stop.sh
./20-start.sh
