#!/bin/bash

# Depends on the aerospace_workspace_change event. 

# Add and configure the active workspace display
sketchybar --add item active_workspace right \
  --subscribe active_workspace aerospace_workspace_change \
  --set active_workspace \
    label.y_offset=0 \
    label.font_size=12 \
    script="$PLUGIN_DIR/active_aerospace.sh"