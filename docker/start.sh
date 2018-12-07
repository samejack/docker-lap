#!/bin/bash

# start supervisord
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf

set -e

# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
        set -- apache2-foreground "$@"
fi

exec "$@"
