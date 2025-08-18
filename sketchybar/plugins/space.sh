#!/bin/bash

# Extract workspace ID from the item name (e.g., space.1 -> 1)
WORKSPACE_ID=${NAME#space.}

update() {
  # Get current focused workspace
  FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused 2>/dev/null)
  
  # Check if this workspace is focused
  if [ "$WORKSPACE_ID" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME icon.highlight=on \
                           icon.color=$RED
  else
    sketchybar --set $NAME icon.highlight=off \
                           icon.color=$ICON_COLOR
  fi
  
  # Get apps in this workspace and create icon strip
  APPS=$(aerospace list-windows --workspace $WORKSPACE_ID --format '%{app-name}' 2>/dev/null | sort -u)
  
  if [ -n "$APPS" ] && [ "$APPS" != "" ]; then
    icon_strip=" "
    while IFS= read -r app; do
      if [ -n "$app" ] && [ "$app" != "" ]; then
        # Use icon_map.sh if you have it, otherwise use app-specific icons
        if [ -f "$HOME/.config/sketchybar/plugins/icon_map.sh" ]; then
          icon_strip+=" $($HOME/.config/sketchybar/plugins/icon_map.sh "$app")"
        else
          # Basic app icon mapping based on your AeroSpace config
          case "$app" in
            "Safari"|"Google Chrome") icon_strip+=" 󰖟" ;;
            "WezTerm") icon_strip+=" " ;;
            "WhatsApp") icon_strip+=" 󰖣" ;;
            "Dictionary") icon_strip+=" 󰗚" ;;
            "Calendar") icon_strip+=" 󰃭" ;;
            "PacketTracer"*) icon_strip+=" 󰒋" ;;
            "Finder") icon_strip+=" 󰉋" ;;
            "Music") icon_strip+=" 󰎆" ;;
            "FaceTime") icon_strip+=" 󰍫" ;;
            "QuickTime"*) icon_strip+=" 󰕧" ;;
            *) icon_strip+=" ${app:0:1}" ;; # Fallback to first letter
          esac
        fi
      fi
    done <<< "$APPS"
    
    sketchybar --set $NAME label="$icon_strip" label.drawing=on
  else
    sketchybar --set $NAME label="" label.drawing=off
  fi
}

mouse_clicked() {
  if [ "$BUTTON" = "right" ]; then
    # For right click, you could implement custom behavior
    # Since AeroSpace doesn't support workspace destruction, maybe show workspace info
    echo "Workspace $WORKSPACE_ID info:"
    aerospace list-windows --workspace $WORKSPACE_ID
  else
    # Focus the workspace using cmd+number (matching your AeroSpace config)
    aerospace workspace $WORKSPACE_ID
  fi
}

case "$SENDER" in
  "mouse.clicked") mouse_clicked
  ;;
  *) update
  ;;
esac
