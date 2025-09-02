#!/bin/bash

# List of regular brew installs
BREW_APPS=(
  meetingbar
  popclip
  lazygit
  ncspot
  awscli
  starship
  ripgrep
  jira-cli
  zsh-autosuggestions
  jj 
  lazyjj
  dotbot
)

# List of cask installs
CASK_APPS=(
  arc
  raycast
  karabiner-elements
  cleanshot
  linearmouse
  maccy
  nikitabobko/tap/aerospace
  jetbrains-toolbox
  iterm2
  mouseless
  obsidian
  visual-studio-code
  cursor
  1password

  # Fonts
  font-hack-nerd-font
  font-meslo-lg-nerd-font
)

# Install regular brew apps if not already installed
for app in "${BREW_APPS[@]}"; do
  if ! brew list --formula | grep -q "^${app}\$"; then
    brew install "$app"
  else
    echo "$app already installed"
  fi
done

# Install cask apps if not already installed
for cask in "${CASK_APPS[@]}"; do
  if ! brew list --cask | grep -q "^${cask}\$"; then
    brew install --cask "$cask"
  else
    echo "$cask already installed"
  fi
done

# Set global git ignore
git config --global core.excludesFile ~/dotfiles/.globalgitignore
