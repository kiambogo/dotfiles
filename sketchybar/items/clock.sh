#!/bin/bash

clock=(
  update_freq=10
  icon= 
  icon.color=$ORANGE
  script="$PLUGIN_DIR/clock.sh"
)

utcclock=(
  update_freq=10
  icon=UTC
  icon.color=$ORANGE
  script="$PLUGIN_DIR/clock.sh"
)

sketchybar  --add item clock right             \
            --set clock "${clock[@]}" 
   	                 
			 
	                 

sketchybar  --add item utcclock right          \
            --set utcclock "${utcclock[@]}"  
	                   
   	                  
	                 
