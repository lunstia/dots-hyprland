#!/bin/bash

read current_x current_y current_width current_height <<< $(hyprctl -j monitors | jq -r '.[] | select(.focused == true) | "\(.x) \(.y) \(.width) \(.height)"')   


grim -g "${current_x},${current_y} ${current_width}x${current_height}" - | wl-copy