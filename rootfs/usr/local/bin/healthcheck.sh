#!/bin/sh

APP_PORT="$1"
APP_NAME="Medusa"

if [ "$(netstat -plnt | grep -c $APP_PORT)" -eq 1 ]; then
  echo "$APP_NAME [$APP_PORT] : Success"
  exit 0
else
  echo "$APP_NAME [$APP_PORT] : Failed"
  exit 1
fi

exit 0
