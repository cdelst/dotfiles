#!/bin/bash

# Add event to subscribe
sketchybar --add event aerospace_workspace_change

# Define your spaces with names, corresponding Nerd Font icons, and vibrant colors
SPACES=("home::0xFFFF5733" "web:󰖟:0xFFE69138" "code::0xFF33FF57" "terminal::0xFF33FFFF" "spotify:󰎆:0xFFFF33A1" "notes:󱞁:0xFF8C33FF")

# Add and configure spaces
for SPACE in "${SPACES[@]}"; do
  WORKSPACE_NAME=${SPACE%%:*} # Extract name (everything before ':')
  ICON_COLOR=${SPACE#*:}      # Extract icon and color (everything after ':')
  ICON=${ICON_COLOR%%:*}      # Extract icon (everything before ':')
  COLOR=${ICON_COLOR##*:}     # Extract color (everything after ':')

  # Add and set space
  sketchybar --add item "workspace.$WORKSPACE_NAME" left \
    --subscribe "workspace.$WORKSPACE_NAME" aerospace_workspace_change \
    --set "workspace.$WORKSPACE_NAME" \
    icon="$ICON" \
    label="$WORKSPACE_NAME" \
    icon.padding_right=5 \
    label.y_offset=0 \
    background.color="$COLOR" \
    click_script="aerospace workspace $WORKSPACE_NAME" \
    script="$PLUGIN_DIR/aerospace.sh $WORKSPACE_NAME"
done
