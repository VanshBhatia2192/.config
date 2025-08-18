#!/bin/bash

for workspace in {1..10}; do
    sketchybar --set space.$workspace script="$HOME/.config/sketchybar/plugins/aerospace_space.sh" \
               --trigger aerospace_workspace_change NAME="space.$workspace"
done
