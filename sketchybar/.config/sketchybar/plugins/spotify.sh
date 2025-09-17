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

update_track() {

    if [[ -z $SPOTIFY_JSON ]]; then
        sketchybar --set $NAME "${offline[@]}"
        return
    fi

    PLAYER_STATE=$(echo "$SPOTIFY_JSON" | jq -r '.["Player State"]')

    if [ $PLAYER_STATE = "Playing" ]; then
        TRACK="$(echo "$SPOTIFY_JSON" | jq -r .Name)"
        ARTIST="$(echo "$SPOTIFY_JSON" | jq -r .Artist)"

        sketchybar --set $NAME label="${TRACK}  ${ARTIST}" "${online[@]}"
    else
        sketchybar --set $NAME icon.color=$YELLOW
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
