#!/bin/bash

# Extract workspace ID from the item name (e.g., space.1 -> 1)
WORKSPACE_ID=${NAME#space.}

update() {
  # Get current focused workspace
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
  
  # Check if this workspace is focused
  if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.color=0xffed8796
  else
    sketchybar --set $NAME background.color=0xff363a4f
  fi
  
  # Get apps in this workspace
  APPS=$(aerospace list-windows --workspace $WORKSPACE_ID --format '%{app-name}' 2>/dev/null | sort -u)
  
  if [ -n "$APPS" ] && [ "$APPS" != "" ]; then
    icon_strip=""
    while IFS= read -r app; do
      if [ -n "$app" ] && [ "$app" != "" ]; then
        case "$app" in
          "Safari"|"Google Chrome") icon_strip+="󰖟" ;;
          "WezTerm") icon_strip+="" ;;
          "WhatsApp") icon_strip+="󰖣" ;;
          *) icon_strip+="${app:0:1}" ;;
        esac
      fi
    done <<< "$APPS"
    
    sketchybar --set $NAME label="$icon_strip" label.drawing=on
  else
    sketchybar --set $NAME label="" label.drawing=off
  fi
}

mouse_clicked() {
  aerospace workspace $WORKSPACE_ID
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked ;;
  *) update ;;
esac
