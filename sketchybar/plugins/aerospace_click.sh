#!/bin/bash

# Simple click handler for workspace switching
WORKSPACE_ID=${NAME#space.}

case "$SENDER" in
  "mouse.clicked")
    if [ "$BUTTON" = "right" ]; then
      # Right click - show workspace info
      aerospace list-windows --workspace $WORKSPACE_ID --format '%{app-name}'
    else
      # Left click - switch to workspace
      aerospace workspace $WORKSPACE_ID
      # Force immediate update
      "$HOME/.config/sketchybar/plugins/direct_aerospace_update.sh"
    fi
    ;;
esac
