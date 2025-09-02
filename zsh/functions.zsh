# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Launch lazygit
function lg() {
  lazygit
}

# Launch lazyjj (jujutsu TUI)
function lj() {
  lazyjj
}

# Kill process on specified port
function killport() {
  if [ -z "$1" ]; then
    echo "Usage: killport <port_number>"
    return 1
  fi
  lsof -ti:$1 | xargs kill -9 2>/dev/null
  if [ $? -eq 0 ]; then
    echo "Killed process on port $1"
  else
    echo "No process found on port $1"
  fi
}