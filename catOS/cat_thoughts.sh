#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║  cat_thoughts.sh — random cat messages  ║
# ║  Fires every 5–15 minutes               ║
# ╚══════════════════════════════════════════╝

msgs=(
    "meow"
    "no."
    "why are you working"
    "feed me"
    "i closed that btw"
    "what was that"
    "don't touch that"
    "i was sitting there"
    "..."
    "you're being watched"
    "that's mine actually"
    "stop"
    "i could delete that"
    "are you done yet"
    "bored"
    "the cursor moved on its own btw"
    "fine"
    "mrrp"
)

while true; do
    # sleep 5–15 minutes (300–900 seconds)
    sleep $(( RANDOM % 600 + 300 ))
    notify-send -a "cat" -i "dialog-information" "🐈 cat" "${msgs[RANDOM % ${#msgs[@]}]}"
done
