#!/bin/sh
touch /tmp/hello
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload mht &
done
