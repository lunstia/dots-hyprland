#!/usr/bin/env bash

LOCKFILE="/tmp/hypr_cursor_teleport.pid"

# If lock exists, check if process is still alive
if [[ -f "$LOCKFILE" ]]; then
    OLD_PID=$(cat "$LOCKFILE")

    if kill -0 "$OLD_PID" 2>/dev/null; then
        echo "Script already running (PID $OLD_PID). Exiting."
        exit 1
    else
        echo "Removing stale lock..."
        rm -f "$LOCKFILE"
    fi
fi

echo $$ > "$LOCKFILE"

while true; do
    pos=$(hyprctl -j cursorpos)

    x=$(echo "$pos" | jq '.x')
    y=$(echo "$pos" | jq '.y')

    if [[ "$x" -eq 1 ]]; then

       new_y=$(( y * 1080 / 1440 ))
        ydotool mousemove --absolute "1915" "$new_y"

    elif [[ "$x" -eq -17 ]]; then

        new_y=$(( y * 1440 / 1080 ))

        ydotool mousemove --absolute "1940" "$new_y"
    fi

    sleep 0.001
done