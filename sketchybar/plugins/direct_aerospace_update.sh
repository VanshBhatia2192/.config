#!/bin/bash

# Optimized direct update - batched commands for speed
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

# Build all commands in one batch for maximum speed
COMMANDS=""

for workspace in {1..10}; do
    if [ "$workspace" = "$FOCUSED" ]; then
        COMMANDS+="--set space.$workspace background.color=0xffcba6f7 icon.color=0xff11111b label.drawing=off "
    else
        COMMANDS+="--set space.$workspace background.color=0xff313244 icon.color=0xffcdd6f4 label.drawing=off "
    fi
done

# Execute all commands in one batch (much faster)
eval "sketchybar $COMMANDS"
