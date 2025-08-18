#!/bin/bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

window_state() {
  # Get focused window info from AeroSpace
  FOCUSED_WINDOW=$(aerospace list-windows --focused --format '%{window-id}:%{app-name}' 2>/dev/null)
  
  if [ -z "$FOCUSED_WINDOW" ]; then
    sketchybar --set $NAME icon=$YABAI_GRID icon.color=$ORANGE label.drawing=off
    return
  fi
  
  # Get current workspace mode (you might need to adjust this based on your AeroSpace config)
  CURRENT_WORKSPACE=$(aerospace list-workspaces --focused)
  
  # AeroSpace doesn't have the same window states as yabai, so we'll use simpler logic
  # You can customize this based on your AeroSpace configuration
  
  args=()
  
  # Check if window is in floating mode (if you have floating enabled in AeroSpace)
  # This is a basic implementation - you might need to adjust based on your setup
  if aerospace list-windows --workspace $CURRENT_WORKSPACE --format '%{window-id}' | grep -q "floating"; then
    args+=(--set $NAME icon=$YABAI_FLOAT icon.color=$MAGENTA label.drawing=off)
  else
    # Default tiled state
    args+=(--set $NAME icon=$YABAI_GRID icon.color=$ORANGE label.drawing=off)
  fi
  
  sketchybar -m "${args[@]}"
}

workspace_windows() {
  # Update all workspace indicators with their windows
  WORKSPACES=$(aerospace list-workspaces --all)
  
  while IFS= read -r workspace; do
    if [ -n "$workspace" ]; then
      # Trigger update for each workspace
      sketchybar --trigger aerospace_workspace_change WORKSPACE_ID="$workspace"
    fi
  done <<< "$WORKSPACES"
}

mouse_clicked() {
  # Toggle floating mode if supported by your AeroSpace config
  # Note: AeroSpace's floating support may be limited compared to yabai
  echo "Window clicked - implement custom behavior here"
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  "aerospace_workspace_change") window_state 
  ;;
  "aerospace_focus_change") window_state
  ;;
  *) window_state
  ;;
esac
