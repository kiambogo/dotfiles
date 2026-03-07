#!/bin/bash

source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

update_battery() {
  BATTERY_INFO="$(pmset -g batt)"
  PERCENTAGE=$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)
  CHARGING=$(echo "$BATTERY_INFO" | grep 'AC Power')

  if [ "$PERCENTAGE" = "" ]; then
    exit 0
  fi

  DRAWING=on
  case ${PERCENTAGE} in
    9[0-9]|100) ICON=$BATTERY_100; COLOR=$GREEN  ;;
    [6-8][0-9]) ICON=$BATTERY_75;  COLOR=$GREEN  ;;
    [3-5][0-9]) ICON=$BATTERY_50;  COLOR=$YELLOW ;;
    [1-2][0-9]) ICON=$BATTERY_25;  COLOR=$ORANGE ;;
    *)          ICON=$BATTERY_0;   COLOR=$RED    ;;
  esac

  if [[ $CHARGING != "" ]]; then
    COLOR=$GREEN
  fi

  sketchybar --set $NAME drawing=$DRAWING icon="$ICON" icon.color=$COLOR label=$PERCENTAGE% label.drawing=on label.color=$WHITE

  # Popup details
  POWER_SOURCE=$(echo "$BATTERY_INFO" | grep -Eo "'[^']+'" | head -1 | tr -d "'")
  TIME_LEFT=$(echo "$BATTERY_INFO" | grep -Eo "\d+:\d+" | head -1)
  [[ -z "$TIME_LEFT" ]] && TIME_LEFT="–"
  HEALTH=$(system_profiler SPPowerDataType 2>/dev/null | awk '/Condition/ {print $2}')
  [[ -z "$HEALTH" ]] && HEALTH="–"
  CYCLES=$(system_profiler SPPowerDataType 2>/dev/null | awk '/Cycle Count/ {print $3}')
  [[ -z "$CYCLES" ]] && CYCLES="–"

  sketchybar --set battery.time   label="$TIME_LEFT" \
             --set battery.source label="$POWER_SOURCE" \
             --set battery.health label="$HEALTH ($PERCENTAGE%)" \
             --set battery.cycles label="$CYCLES cycles"
}

toggle_popup() {
  sketchybar --set $NAME popup.drawing=toggle
}

case "$SENDER" in
  "mouse.clicked")      toggle_popup ;;
  "mouse.exited.global") sketchybar --set $NAME popup.drawing=off ;;
  *)                    update_battery ;;
esac
