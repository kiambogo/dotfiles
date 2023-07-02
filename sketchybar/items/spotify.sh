#!/bin/bash

SPOTIFY_EVENT="com.spotify.client.PlaybackStateChanged"

spotify=(
  icon= 
  icon.y_offset=1
  icon.font="$FONT:Bold:20.0"
  label.drawing=off 
  label.padding_left=3
  script="$PLUGIN_DIR/spotify.sh"
)

status_bracket=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  background.border_width=2
)

sketchybar --add event spotify_change $SPOTIFY_EVENT \
           --add item spotify left \
           --set spotify "${spotify[@]}" \
           --subscribe spotify spotify_change mouse.clicked

sketchybar --add bracket spotify_status spotify \
           --set spotify_status "${status_bracket[@]}"
