#!/bin/bash

set -euo pipefail

source ./build.ini

./10-create-img.sh
./20-create-ctn.sh
