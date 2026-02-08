#!/usr/bin/env bash
set -euo pipefail

# Icons to download from lucide (https://lucide.dev/icons)
# Edit this list to add/remove icons as needed
ICONS=(
    wifi
    wifi-off
    bluetooth
    bluetooth-off
    battery
    battery-low
    battery-charging
    battery-warning
    volume-2
    volume-1
    volume-x
    search
    x
    settings
    power
    sun
    moon
    bell
    bell-off
    chevron-down
    chevron-up
    clock
    keyboard
)

BASE_URL="https://raw.githubusercontent.com/lucide-icons/lucide/main/icons"
DIR="$(cd "$(dirname "$0")/source" && pwd)"

echo "Downloading ${#ICONS[@]} icons..."

for icon in "${ICONS[@]}"; do
    out="$DIR/$icon.svg"
    if curl -fsSL "$BASE_URL/$icon.svg" -o "$out"; then
        echo "  $icon.svg"
    else
        echo "  FAILED: $icon.svg" >&2
    fi
done

echo "Done."
