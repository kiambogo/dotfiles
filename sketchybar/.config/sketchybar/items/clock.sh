#!/bin/bash

clock=(
  update_freq=1
  icon= 
  icon.color=$ORANGE
  script="$PLUGIN_DIR/clock.sh"
)

utcclock=(
  update_freq=1
  icon=UTC
  icon.color=$ORANGE
  script="$PLUGIN_DIR/clock.sh"
  background.padding_right=0
)

sketchybar  --add item clock right             \
            --set clock "${clock[@]}"          \
   	    --add item utcclock right          \
	    --set utcclock "${utcclock[@]}"         	 
