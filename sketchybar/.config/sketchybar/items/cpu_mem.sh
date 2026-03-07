#!/bin/bash

source "$CONFIG_DIR/colors.sh"

cpu=(
  icon="󰍛"
  icon.font="$FONT:Bold:14.0"
  icon.color=$BLUE
  label="–%  󰓡 –"
  label.font="$FONT:Bold:13.0"
  label.color=$GREY
  update_freq=5
  script="$PLUGIN_DIR/cpu_mem.sh"
  background.drawing=off
  padding_left=4
  padding_right=4
  popup.align=right
  popup.background.color=$BACKGROUND_1
  popup.background.border_color=$BACKGROUND_2
  popup.background.border_width=2
  popup.background.corner_radius=9
  popup.background.shadow.drawing=on
  popup.y_offset=2
)

sketchybar --add item cpu right \
           --set cpu "${cpu[@]}" \
           --subscribe cpu mouse.clicked mouse.exited.global

# Header
sketchybar --add item cpu.header popup.cpu \
           --set cpu.header \
             icon="PROCESS             CPU              MEM" \
             icon.font="$FONT:Bold:11.0" \
             icon.color=$GREY \
             icon.padding_left=12 \
             icon.padding_right=12 \
             label.drawing=off \
             background.drawing=off

# 5 process rows
for i in 1 2 3 4 5; do
  sketchybar --add item cpu.proc$i popup.cpu \
             --set cpu.proc$i \
               icon="–" \
               icon.font="$FONT:Mono:12.0" \
               icon.color=$WHITE \
               icon.width=140 \
               icon.padding_left=12 \
               label="" \
               label.font="$FONT:Mono:12.0" \
               label.color=$GREY \
               label.padding_right=12 \
               background.drawing=off
done
