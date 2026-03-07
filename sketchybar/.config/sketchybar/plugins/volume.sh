#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

update_volume() {
  VOL=$(osascript -e "output volume of (get volume settings)")
  MUTED=$(osascript -e "output muted of (get volume settings)")

  case $VOL in
    [6-9][0-9]|100) ICON=$VOLUME_100 ;;
    [3-5][0-9])     ICON=$VOLUME_66  ;;
    [1-2][0-9])     ICON=$VOLUME_33  ;;
    [1-9])          ICON=$VOLUME_10  ;;
    0)              ICON=$VOLUME_0   ;;
    *)              ICON=$VOLUME_100 ;;
  esac

  [[ "$MUTED" == "true" ]] && ICON=$VOLUME_0

  OUTPUT=$(system_profiler SPAudioDataType 2>/dev/null | awk '
    /^        [^ ]/ { device = substr($0, 9); gsub(/:$/, "", device) }
    /Default Output Device: Yes/ { print device; exit }
  ')
  INPUT=$(system_profiler SPAudioDataType 2>/dev/null | awk '
    /^        [^ ]/ { device = substr($0, 9); gsub(/:$/, "", device) }
    /Default Input Device: Yes/ { print device; exit }
  ')
  [[ -z "$OUTPUT" ]] && OUTPUT="Default Output"
  [[ -z "$INPUT"  ]] && INPUT="Default Input"

  sketchybar --set volume icon="$ICON" label="${VOL}%" \
             --set volume.output label="$OUTPUT" \
             --set volume.input  label="$INPUT" \
             --set volume.slider slider.percentage=$VOL
}

toggle_popup() {
  sketchybar --set volume popup.drawing=toggle
  update_volume
}

case "$SENDER" in
  "mouse.clicked")
    if [[ "$NAME" == "volume.slider" ]]; then
      osascript -e "set volume output volume $PERCENTAGE"
    elif [[ "$NAME" == "volume.settings" ]]; then
      open '/System/Library/PreferencePanes/Sound.prefPane'
      sketchybar --set volume popup.drawing=off
    else
      toggle_popup
    fi
    ;;
  "mouse.exited.global") sketchybar --set volume popup.drawing=off ;;
  "volume_change")       update_volume ;;
  *)                     update_volume ;;
esac
