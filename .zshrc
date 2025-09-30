# =============================================================================
# ZSH CONFIGURATION
# =============================================================================

# Oh My Zsh installation path
export ZSH="$HOME/.oh-my-zsh"

# Oh My Zsh plugins
plugins=(
    git                    # Auto included
    z                      # Auto included  
    zsh-autosuggestions   # https://github.com/zsh-users/zsh-autosuggestions
    zsh-syntax-highlighting # https://github.com/zsh-users/zsh-syntax-highlighting
    you-should-use        # https://github.com/MichaelAquilina/zsh-you-should-use
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =============================================================================
# LOAD CUSTOM CONFIGURATIONS
# =============================================================================

# Load all custom zsh configurations
for config_file in ~/.config/zsh/*.zsh; do
    [[ -r "$config_file" ]] && source "$config_file"
done
# Created by `pipx` on 2025-09-29 23:12:01
export PATH="$PATH:/Users/cdelst/.local/bin"
