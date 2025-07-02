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
# Prompt Configuration
# =============================================================================
__powerline() {
    # Colors
    COLOR_RESET='\[\033[m\]'
    COLOR_CWD=${COLOR_CWD:-'\[\033[0;34m\]'} # blue
    COLOR_GIT=${COLOR_GIT:-'\[\033[0;36m\]'} # cyan
    COLOR_GIT_DIRTY=${COLOR_GIT_DIRTY:-'\[\033[0;31m\]'} # red for dirty repos
    COLOR_SUCCESS=${COLOR_SUCCESS:-'\[\033[0;32m\]'} # green
    COLOR_FAILURE=${COLOR_FAILURE:-'\[\033[0;31m\]'} # red
    COLOR_TIME=${COLOR_TIME:-'\[\033[0;90m\]'} # gray for timestamp

    # Symbols
    SYMBOL_GIT_PUSH=${SYMBOL_GIT_PUSH:-↑}
    SYMBOL_GIT_PULL=${SYMBOL_GIT_PULL:-↓}

    if [[ -z "$PS_SYMBOL" ]]; then
         PS_SYMBOL='$'
    fi

    __git_branch() {
        git rev-parse --abbrev-ref HEAD 2>/dev/null
    }

    __git_info() {
        [[ $POWERLINE_GIT = 0 ]] && return # disabled
        hash git 2>/dev/null || return # git not found
        local git_eng="env LANG=C git"   # force git output in English to make our work easier

        # get current branch name
        local ref=$($git_eng symbolic-ref --short HEAD 2>/dev/null)

        if [[ -n "$ref" ]]; then
            ref=$ref
        else
            # get tag name or short unique hash
            ref=$($git_eng describe --tags --always 2>/dev/null)
        fi

        [[ -n "$ref" ]] || return  # not a git repo

        local marks
        local is_dirty=false

        # scan first two lines of output from `git status`
        while IFS= read -r line; do
            if [[ $line =~ ^## ]]; then # header line
                [[ $line =~ ahead\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PUSH${BASH_REMATCH[1]}"
                [[ $line =~ behind\ ([0-9]+) ]] && marks+=" $SYMBOL_GIT_PULL${BASH_REMATCH[1]}"
            else # branch is modified if output contains more lines after the header line
                is_dirty=true
                break
            fi
        done < <($git_eng status --porcelain --branch 2>/dev/null)  # note the space between the two

        # Return both the git info and dirty status
        printf " $ref$marks|$is_dirty"
    }

    ps1() {
        local symbol="$COLOR_SUCCESS $PS_SYMBOL $COLOR_RESET"
        local timestamp="$COLOR_TIME[\D{%a %H:%M:%S}]$COLOR_RESET "

        local cwd="$COLOR_CWD\w$COLOR_RESET"

        local git_branch="$(__git_branch)"

        # Only show git info if we're in a git repository
        if [[ -n "$git_branch" ]]; then
            local git_color="$COLOR_GIT"
            local git=" $git_color[$git_branch]$COLOR_RESET"
        else
            local git=""
        fi

        PS1="$timestamp$cwd$git$symbol"
    }

    PROMPT_COMMAND="ps1${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
}

__powerline
unset __powerline


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
