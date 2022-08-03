#!/bin/sh

MEDUSA_BRANCH=${MEDUSA_BRANCH:-develop}

if  [ ! -f /app/start.py ]; then
  git clone -b ${MEDUSA_BRANCH} https://github.com/pymedusa/Medusa.git /app
else
  git -C /app pull
fi

python3 /app/start.py --nolaunch --datadir /config
