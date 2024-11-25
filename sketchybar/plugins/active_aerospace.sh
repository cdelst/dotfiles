#!/bin/bash

# Get the current active workspace name
ACTIVE_WORKSPACE=$(aerospace list-workspaces --focused)

# Update the active workspace label in sketchybar
sketchybar --set "active_workspace" label="$ACTIVE_WORKSPACE"