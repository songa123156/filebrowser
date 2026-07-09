#!/bin/bash
set -xe
cd "$(dirname "$0")"

. ./container.ini

case "$1" in
update)
  set -u
  user=$2
  pass=$3
  admin_flag="${4:-}"
  if [[ "$admin_flag" == "admin" ]]; then
    docker exec -it $container_name ./filebrowser set -u "$user" "$pass" -a
  else
    docker exec -it $container_name ./filebrowser set -u "$user" "$pass" -s /srv
  fi
  ;;
delete)
  set -u
  user=$2
  echo "FileBrowser CLI in this source tree does not expose a delete-user command."
  echo "Delete user '$user' from the web admin UI."
  ;;
*)
  echo "usage: ./60-user.sh update <user> <password> [admin]"
  echo "usage: ./60-user.sh delete <user>"
  ;;
esac
