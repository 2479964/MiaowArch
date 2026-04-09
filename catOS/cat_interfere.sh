#!/bin/bash
# ╔══════════════════════════════════════════╗
# ║  cat_interfere.sh — fake system noise   ║
# ║  Cryptic messages, very rarely          ║
# ║  Fires every 15–45 minutes              ║
# ╚══════════════════════════════════════════╝

msgs=(
    "something moved"
    "that wasn't me"
    "I didn't do that"
    "weird"
    "you didn't see that"
    "..."
    "system nominal. probably."
    "the noise was nothing"
    "cat activity: unconfirmed"
    "an event occurred"
)

while true; do
    # sleep 15–45 minutes (900–2700 seconds)
    sleep $(( RANDOM % 1800 + 900 ))

    notify-send -a "cat" -t 4000 "🐈‍⬛ cat" "${msgs[RANDOM % ${#msgs[@]}]}"
done
