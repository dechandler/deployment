#!/bin/bash

START=4500:0.8
TEMP_FILE="${HOME}/shm/.redshift-temp"
echo "$START" > $TEMP_FILE

# TODO: dbus-daemon?

trap "pgrep -x redshift | xargs kill &>/dev/null" EXIT

while /bin/true; do
    SETTINGS=$(cat $TEMP_FILE)
    TEMP=$(cut -d':' -f1 <<< $SETTINGS)
    BRIGHT=$(cut -d':' -f2 <<< $SETTINGS)

    pgrep -x redshift | xargs kill &>/dev/null
    redshift -O $TEMP -b $BRIGHT &>/dev/null &
    inotifywait -e modify -qq $TEMP_FILE
done
