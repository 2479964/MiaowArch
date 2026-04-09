#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║  cat_nudge.sh — tiny cursor movement    ║
# ║  Barely noticeable, that's the point    ║
# ║  Fires every 10–30 minutes              ║
# ╚══════════════════════════════════════════╝

while true; do
    # sleep 10–30 minutes (600–1800 seconds)
    sleep $(( RANDOM % 1200 + 600 ))

    x=$(( RANDOM % 5 - 2 ))
    y=$(( RANDOM % 5 - 2 ))

    # skip a no-op nudge (0,0)
    if [[ $x -eq 0 && $y -eq 0 ]]; then
        x=1
    fi

    hyprctl dispatch movecursor "$x" "$y"
done
