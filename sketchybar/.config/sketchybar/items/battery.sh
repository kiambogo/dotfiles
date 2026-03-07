#!/bin/bash

battery=(
  script="$PLUGIN_DIR/battery.sh"
  icon.font="$FONT:Regular:19.0"
  padding_right=5
  padding_left=0
  update_freq=120
  updates=on
  popup.align=right
  popup.background.color=$BACKGROUND_1
  popup.background.border_color=$BACKGROUND_2
  popup.background.border_width=2
  popup.background.corner_radius=9
  popup.background.shadow.drawing=on
  popup.horizontal=off
  popup.y_offset=2
)

sketchybar --add item battery right \
           --set battery "${battery[@]}" \
           --subscribe battery power_source_change system_woke mouse.clicked mouse.exited.global

# Popup items
sketchybar --add item battery.time   popup.battery \
           --set battery.time   icon="󱑂" icon.color=$BLUE    label="–" \
                                icon.font="$FONT:Bold:14.0"  \
                                label.font="$FONT:Bold:13.0" \
                                padding_left=12 padding_right=12 \
                                icon.padding_right=8 \
           \
           --add item battery.source  popup.battery \
           --set battery.source icon="󰚥" icon.color=$GREEN   label="–" \
                                icon.font="$FONT:Bold:14.0"  \
                                label.font="$FONT:Bold:13.0" \
                                padding_left=12 padding_right=12 \
                                icon.padding_right=8 \
           \
           --add item battery.health  popup.battery \
           --set battery.health icon="󰤓" icon.color=$MAGENTA label="–" \
                                icon.font="$FONT:Bold:14.0"  \
                                label.font="$FONT:Bold:13.0" \
                                padding_left=12 padding_right=12 \
                                icon.padding_right=8 \
           \
           --add item battery.cycles  popup.battery \
           --set battery.cycles icon="󰑐" icon.color=$GREY    label="–" \
                                icon.font="$FONT:Bold:14.0"  \
                                label.font="$FONT:Bold:13.0" \
                                padding_left=12 padding_right=12 \
                                icon.padding_right=8
