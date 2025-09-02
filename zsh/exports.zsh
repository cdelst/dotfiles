# =============================================================================
# EXPORTS & PATH CONFIGURATION
# =============================================================================

# Netflix-specific paths
export PATH=/opt/nflx:/opt/nflx/bin:$PATH

# Custom bin directory for tools like `idea`
export PATH=/Users/cdelst/bin:$PATH

# JIRA API Token (from secure file)
export JIRA_API_TOKEN=$(cat $HOME/dotfiles/.jira_token)

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# SDKMAN Configuration (must be at end)
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"