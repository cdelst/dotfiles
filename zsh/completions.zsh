# =============================================================================
# COMPLETIONS & EXTERNAL TOOL CONFIGURATION
# =============================================================================

# Initialize completions
autoload -Uz compinit
compinit

# Tool completions
source <(jira completion zsh)
source <(jj util completion zsh)
source <(fzf --zsh)

# Homebrew zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Graphite completions
_gt_yargs_completions() {
  local reply
  local si=$IFS
  IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt

# Starship prompt (must be near end)
eval "$(starship init zsh)"