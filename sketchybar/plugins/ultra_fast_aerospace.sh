#!/bin/bash

# Ultra fast monitor - 50ms polling
pkill -f "ultra_fast_aerospace" 2>/dev/null
pkill -f "aerospace_simple_loop" 2>/dev/null

LAST_WORKSPACE=""

# Immediate first update
"$HOME/.config/sketchybar/plugins/direct_aerospace_update.sh"

while true; do
    CURRENT_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
    
    if [ "$CURRENT_WORKSPACE" != "$LAST_WORKSPACE" ]; then
        # Run update in background for speed
        "$HOME/.config/sketchybar/plugins/direct_aerospace_update.sh" &
        LAST_WORKSPACE="$CURRENT_WORKSPACE"
    fi
    
    # 50ms intervals = 20 updates per second
    sleep 0.05
done
