#!/bin/bash

# Kill any existing loops
pkill -f "aerospace_simple_loop" 2>/dev/null

LAST_STATE=""

while true; do
    # Get current state
    CURRENT_STATE=$(aerospace list-workspaces --focused):$(aerospace list-windows --all --format '%{workspace}' | sort | uniq -c)
    
    # Only update if something changed
    if [ "$CURRENT_STATE" != "$LAST_STATE" ]; then
        "$HOME/.config/sketchybar/plugins/direct_aerospace_update.sh"
        LAST_STATE="$CURRENT_STATE"
    fi
    
    sleep 0.5
done
