#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

volume=(
  icon=$VOLUME_100
  icon.font="$FONT:Regular:14.0"
  icon.color=$GREY
  icon.padding_right=6
  label="–%"
  label.font="$FONT:Bold:13.0"
  label.color=$WHITE
  label.padding_left=4
  script="$PLUGIN_DIR/volume.sh"
  updates=on
  background.drawing=off
  padding_left=6
  padding_right=6
  popup.align=right
  popup.background.color=$BACKGROUND_1
  popup.background.border_color=$BACKGROUND_2
  popup.background.border_width=2
  popup.background.corner_radius=9
  popup.background.shadow.drawing=on
  popup.y_offset=2
)

sketchybar --add item volume right \
           --set volume "${volume[@]}" \
           --subscribe volume volume_change mouse.clicked mouse.exited.global

# Output device
sketchybar --add item volume.output popup.volume \
           --set volume.output \
             icon="󰋋" \
             icon.font="$FONT:Bold:14.0" \
             icon.color=$BLUE \
             icon.padding_left=12 \
             icon.padding_right=8 \
             label="–" \
             label.font="$FONT:Bold:13.0" \
             label.color=$WHITE \
             label.padding_right=12 \
             background.drawing=off

# Input device
sketchybar --add item volume.input popup.volume \
           --set volume.input \
             icon="󰍬" \
             icon.font="$FONT:Bold:14.0" \
             icon.color=$GREEN \
             icon.padding_left=12 \
             icon.padding_right=8 \
             label="–" \
             label.font="$FONT:Bold:13.0" \
             label.color=$WHITE \
             label.padding_right=12 \
             background.drawing=off

# Volume slider
sketchybar --add slider volume.slider popup.volume \
           --set volume.slider \
             slider.highlight_color=$BLUE \
             slider.background.height=5 \
             slider.background.corner_radius=3 \
             slider.background.color=$BACKGROUND_2 \
             slider.knob="●" \
             slider.knob.drawing=on \
             slider.width=200 \
             padding_left=12 \
             padding_right=12 \
             label.drawing=off \
             icon.drawing=off \
             script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume.slider mouse.clicked

# Sound settings shortcut
sketchybar --add item volume.settings popup.volume \
           --set volume.settings \
             icon="󰒓" \
             icon.font="$FONT:Bold:14.0" \
             icon.color=$GREY \
             icon.padding_left=12 \
             icon.padding_right=8 \
             label="Sound Settings" \
             label.font="$FONT:Bold:13.0" \
             label.color=$GREY \
             label.padding_right=12 \
             background.drawing=off \
             updates=off \
             script="$PLUGIN_DIR/volume.sh" \
           --subscribe volume.settings mouse.clicked
