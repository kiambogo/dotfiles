#!/bin/bash

volume_slider=(
  script="$PLUGIN_DIR/volume.sh"
  updates=on
  label.drawing=off
  icon.drawing=off
  slider.highlight_color=$ORANGE
  slider.background.height=5
  slider.background.corner_radius=3
  slider.background.color=$BACKGROUND_2
  slider.knob=􀀁
  slider.knob.drawing=off
)

volume_icon=(
  script="$PLUGIN_DIR/volume.sh"
  padding_left=10
  padding_right=10
  icon=$VOLUME_100
  icon.width=0
  icon.align=left
  icon.color=$GREY
  icon.font="$FONT:Regular:14.0"
  label.width=25
  label.align=left
  label.font="$FONT:Regular:14.0"
)

status_bracket=(
  script="$PLUGIN_DIR/volume.sh"
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  background.border_width=2
)

sketchybar --add slider volume right             \
           --set volume "${volume_slider[@]}"    \
           --subscribe volume volume_change      \
	                      mouse.clicked      \
                                                 \
           --add item volume_icon right          \
           --set volume_icon "${volume_icon[@]}" \

sketchybar --add bracket status volume_icon volume \
           --set status "${status_bracket[@]}"     \
           --subscribe status     mouse.entered    \
                                   mouse.exited      
