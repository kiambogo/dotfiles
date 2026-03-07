#!/bin/bash
#
source "$CONFIG_DIR/colors.sh"

# Spotify JSON / $INFO comes in malformed, line below sanitizes it
SPOTIFY_JSON="$INFO"

offline=(
  icon.color=$RED
  label="ERROR"
  label.drawing=on
  label.color=$RED
)

online=(
  icon.color=$GREEN
  label.drawing=on
  label.color=$WHITE
)

EQ_FRAMES=("▁▂▃" "▂▃▄" "▃▄▅" "▄▅▆" "▅▆▇" "▄▅▆" "▃▄▅" "▂▃▄")
EQ_FRAME_FILE="/tmp/sketchybar_spotify_eq_frame"

next_eq_frame() {
  current=$(cat "$EQ_FRAME_FILE" 2>/dev/null || echo "0")
  next=$(( (current + 1) % ${#EQ_FRAMES[@]} ))
  echo "$next" > "$EQ_FRAME_FILE"
  echo "${EQ_FRAMES[$next]}"
}

update_track() {
  if [[ -z $SPOTIFY_JSON ]]; then
    sketchybar --set $NAME label.drawing=off icon.color=$GREY
    return
  fi

  PLAYER_STATE=$(echo "$SPOTIFY_JSON" | jq -r '.["Player State"]')

  if [ $PLAYER_STATE = "Playing" ]; then
    TRACK="$(echo "$SPOTIFY_JSON" | jq -r .Name)"
    ARTIST="$(echo "$SPOTIFY_JSON" | jq -r .Artist)"
    EQ="$(next_eq_frame)"

    sketchybar --set $NAME label="${EQ}  ${TRACK}  ${ARTIST}" "${online[@]}"
  else
    rm -f "$EQ_FRAME_FILE"
    sketchybar --set $NAME icon.color=$YELLOW label.drawing=off
  fi
}

case "$SENDER" in
"mouse.clicked")
  osascript -e 'tell application "Spotify" to playpause'
  ;;
*)
  update_track
  ;;
esac
