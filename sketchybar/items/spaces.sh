#!/bin/bash

# AeroSpace workspace configuration
# Matching your AeroSpace config workspaces 1-10
WORKSPACES=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")

# Destroy workspace on right click, focus workspace on left click.
for i in "${!WORKSPACES[@]}"
do
  workspace_id=${WORKSPACES[i]}

  space=(
    associated_display=1
    icon="$workspace_id"
    icon.padding_left=10
    icon.padding_right=15
    padding_left=2
    padding_right=2
    label.padding_right=20
    icon.highlight_color=$RED
    label.font="sketchybar-app-font:Regular:16.0"
    label.background.height=26
    label.background.drawing=on
    label.background.color=$BACKGROUND_2
    label.background.corner_radius=8
    label.drawing=off
    script="$PLUGIN_DIR/aerospace_space.sh"
  )

  sketchybar --add item space.$workspace_id left    \
             --set space.$workspace_id "${space[@]}" \
             --subscribe space.$workspace_id aerospace_workspace_change mouse.clicked
done

# Bracket all spaces together
spaces=(
  background.color=$BACKGROUND_1
  background.border_color=$BACKGROUND_2
  background.border_width=2
  background.drawing=on
)

sketchybar --add bracket spaces '/space\..*/' \
           --set spaces "${spaces[@]}"
