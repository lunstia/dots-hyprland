#!/bin/bash

monitors=$(hyprctl monitors -j)
count=$(jq length <<< $monitors)

if [ $count -ne 2 ]; then
    echo "This only works when two monitors are active!"
    exit
fi

function getWindows() {
    local -n arr=$1
    for ((i=0; i<$2; i++)); do
        active_window=$(hyprctl activewindow -j | jq -r '.address')
        arr[i]=$active_window
        hyprctl dispatch cyclenext
    done
}

declare -a w_1_windows
declare -a w_2_windows

w_1=$(hyprctl activeworkspace -j)
w_1_count=$(echo $w_1 | jq -r '.windows')
getWindows w_1_windows $w_1_count

hyprctl dispatch focusmonitor -1

w_2=$(hyprctl activeworkspace -j)
w_2_count=$(echo $w_2 | jq -r '.windows')
getWindows w_2_windows $w_2_count

if (( w_2_count > w_1_count )); then
    h=w_2_windows
    l=w_1_windows
else
    h=w_1_windows
    l=w_2_windows
fi

declare -n highest=$h
declare -n lowest=$l


for ((i=0; i < ${#highest[@]}; i++)); do
    current=${highest[i]}
    target=${lowest[i]}

    if [[ -n $target ]]; then
        hyprctl dispatch focuswindow "address:$current"
        hyprctl dispatch swapwindow "address:$target"
    else
        hyprctl dispatch focuswindow "address:$current"
        hyprctl dispatch movewindow mon:-1 silent
    fi
done