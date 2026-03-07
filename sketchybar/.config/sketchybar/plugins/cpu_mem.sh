#!/bin/bash

source "$CONFIG_DIR/colors.sh"

update_stats() {
  CPU=$(top -l 1 -s 0 | awk '/CPU usage/ {gsub(/%/,""); print int($3 + $5)}')

  MEM_TOTAL=$(sysctl -n hw.memsize)
  MEM_USED=$(vm_stat | awk '
    /Pages active/   { active = $3 }
    /Pages wired/    { wired = $4 }
    END { printf "%d", (active + wired) * 4096 }
  ')
  MEM_TOTAL_GB=$(( MEM_TOTAL / 1073741824 ))
  MEM_USED_GB_RAW=$(echo "scale=1; $MEM_USED / 1073741824" | bc)
  MEM_LABEL="${MEM_USED_GB_RAW}/${MEM_TOTAL_GB}GB"

  cpu_color() {
    if   [[ $1 -ge 80 ]]; then echo $RED
    elif [[ $1 -ge 50 ]]; then echo $ORANGE
    else echo $GREY
    fi
  }

  CPU_COLOR=$(cpu_color $CPU)

  sketchybar --set cpu \
    icon.color=$BLUE \
    label="${CPU}%" \
    label.color=$CPU_COLOR

  sketchybar --set mem \
    icon.color=$BLUE \
    label="$MEM_LABEL" \
    label.color=$GREY

  # Refresh popup if open
  POPUP_OPEN=$(sketchybar --query cpu | jq -r '.popup.drawing')
  if [[ "$POPUP_OPEN" == "on" ]]; then
    "$CONFIG_DIR/plugins/cpu_detail.sh"
  fi
}

case "$SENDER" in
  "mouse.clicked")
    sketchybar --set cpu popup.drawing=toggle
    POPUP_OPEN=$(sketchybar --query cpu | jq -r '.popup.drawing')
    if [[ "$POPUP_OPEN" == "on" ]]; then
      "$CONFIG_DIR/plugins/cpu_detail.sh"
    fi
    ;;
  "mouse.exited.global") sketchybar --set cpu popup.drawing=off ;;
  *)                     update_stats ;;
esac
