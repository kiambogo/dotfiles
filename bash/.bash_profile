#!/bin/bash

# =============================================================================
# Bash Profile Configuration
# =============================================================================

# Silence macOS bash deprecation warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# =============================================================================
# PATH Configuration
# =============================================================================

# Function to safely add to PATH (avoids duplicates)
add_to_path() {
    if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# Add directories to PATH
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/go/bin"

# macOS-specific PATH additions
if [[ $(uname) == 'Darwin' ]]; then
    # Use Homebrew's recommended shellenv for proper setup
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

# =============================================================================
# Environment Variables
# =============================================================================

export EDITOR='emacsclient -n'
export GOPATH="$HOME/go"
export FZF_DEFAULT_COMMAND='ag -g ""'
export _JAVA_AWT_WM_NONREPARENTING=1  # Java GUI apps in tiling WMs
export TERRAGRUNT_SOURCE_UPDATE=true
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export COLORTERM=truecolor

# Project-specific variables
export SOURCE="$HOME/source"
export VENV="$SOURCE/.venv"

# =============================================================================
# Aliases
# =============================================================================

alias ll='ls -alGh'
alias vim='NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim'
alias em='emacsclient -n'
alias uuid='uuidgen | tr "[:upper:]" "[:lower:]"'
alias asl='aws sso login --profile'

# =============================================================================
# Functions
# =============================================================================

# Increase file descriptor limit
ulimit -S -n 40000


# =============================================================================
# Source External Files
# =============================================================================

# Function to safely source files
safe_source() {
    [[ -f "$1" ]] && source "$1"
}

# Source bash completion
if [[ $(uname) == 'Darwin' ]]; then
    # Use Homebrew's bash completion if available
    if command -v brew >/dev/null 2>&1; then
        brew_prefix=$(brew --prefix 2>/dev/null)
        safe_source "$brew_prefix/etc/profile.d/bash_completion.sh"
        safe_source "$brew_prefix/etc/bash_completion"
    fi
fi

# Source additional completion files
safe_source /usr/local/etc/bash_completion
safe_source ~/.git-completion.bash
safe_source ~/.git-prompt.sh

# =============================================================================
# Local Customizations
# =============================================================================

# Source local bash profile for machine-specific customizations
safe_source ~/.bash_profile.local

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(starship init bash)"
