#!/bin/sh

if [ "$NAME" = "utcclock" ]; then
	sketchybar --set $NAME label="$(date -u '+%H:%M:%S')"
else
	sketchybar --set $NAME label="$(date '+%d/%m | %H:%M:%S')"
fi
