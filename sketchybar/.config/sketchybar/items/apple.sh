#!/bin/bash

source "$CONFIG_DIR/icons.sh"

POPUP_OFF="sketchybar --set apple.logo popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

apple_logo=(
  icon=􀣺
  icon.font="$FONT:Bold:20.0"
  icon.color=$ORANGE
  label.drawing=on
  click_script="$POPUP_CLICK_SCRIPT"
  y_offset=2
)

apple_prefs=(
  icon=$PREFERENCES
  icon.font="$FONT:Bold:20.0"
  icon.color=$ORANGE
  label="Preferences"
  label.padding_left=10
  click_script="open -a 'System Preferences'; $POPUP_OFF"
)

apple_activity=(
  icon=$ACTIVITY
  icon.font="$FONT:Bold:20.0"
  icon.color=$ORANGE
  label="Activity"
  label.padding_left=10
  click_script="open -a 'Activity Monitor'; $POPUP_OFF"
)

apple_lock=(
  icon=$LOCK
  icon.font="$FONT:Bold:20.0"
  icon.color=$ORANGE
  label="Lock Screen"
  label.padding_left=10
  click_script="pmset displaysleepnow; $POPUP_OFF"
)

sketchybar --add item apple.logo left                  \
           --set apple.logo "${apple_logo[@]}"         \
                                                       \
           --add item apple.prefs popup.apple.logo     \
           --set apple.prefs "${apple_prefs[@]}"       \
                                                       \
           --add item apple.activity popup.apple.logo  \
           --set apple.activity "${apple_activity[@]}" \
                                                       \
           --add item apple.lock popup.apple.logo      \
           --set apple.lock "${apple_lock[@]}"

