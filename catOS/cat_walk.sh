#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║  cat_walk.sh — cat walked on keyboard   ║
# ║  Switches workspace every 10–25 min     ║
# ║  (rare = funny, frequent = uninstall)   ║
# ╚══════════════════════════════════════════╝

while true; do
    # sleep 10–25 minutes (600–1500 seconds)
    sleep $(( RANDOM % 900 + 600 ))

    target=$(( RANDOM % 5 + 1 ))
    hyprctl dispatch workspace "$target"

    # subtle notification so you know what happened
    notify-send -a "cat" -t 3000 "🐾 cat" "keyboard incident (ws $target)"
done
