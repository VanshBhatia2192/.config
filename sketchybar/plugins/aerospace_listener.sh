#!/bin/bash

# Optimized AeroSpace Event Listener for SketchyBar
# Since you have exec-on-workspace-change configured, we don't need to poll as aggressively

# Function to update all workspace indicators
update_workspaces() {
    # Get all workspaces and update their indicators
    for workspace in {1..10}; do
        sketchybar --trigger aerospace_workspace_change NAME="space.$workspace"
    done
}

# Function to update focused window state
update_focus() {
    sketchybar --trigger aerospace_focus_change
}

# Initial update
update_workspaces
update_focus

# Since AeroSpace will trigger workspace changes via exec-on-workspace-change,
# we only need to monitor for window focus changes and new windows
CURRENT_FOCUSED=""
CURRENT_WINDOWS=""

while true; do
    # Get current focused window
    NEW_FOCUSED=$(aerospace list-windows --focused --format '%{window-id}' 2>/dev/null)
    
    # Get current windows layout (lighter check than full window list)
    NEW_WINDOWS=$(aerospace list-windows --all --format '%{window-id}:%{workspace}' 2>/dev/null | wc -l)
    
    # Check if focused window changed
    if [ "$NEW_FOCUSED" != "$CURRENT_FOCUSED" ]; then
        CURRENT_FOCUSED="$NEW_FOCUSED"
        update_focus
    fi
    
    # Check if number of windows changed (new window opened/closed)
    if [ "$NEW_WINDOWS" != "$CURRENT_WINDOWS" ]; then
        CURRENT_WINDOWS="$NEW_WINDOWS"
        update_workspaces
    fi
    
    # Longer poll interval since workspace changes are handled by AeroSpace hook
    sleep 1
done
