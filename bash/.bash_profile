# Aliases
alias ll='ls -alGh'
alias vim='NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim'
alias em='emacsclient -n'
alias uuid='uuidgen | tr "[A-Z]" "[a-z]"'


# Environment Variables
export FZF_DEFAULT_COMMAND='ag -g ""'
export EDITOR='emacsclient -n'
export BASH_SILENCE_DEPRECATION_WARNING=1
export GO111MODULE=on
export GOPATH=~/go
export PATH=$GOPATH/bin:~/.local/bin:$PATH
export _JAVA_AWT_WM_NONREPARENTING=1 # Java GUI apps in sway


# Sourced files
source ~/git/dotfiles/git/.git-prompt.sh


# Functions
ulimit -S -n 40000


# Shell Customization
IWhite="\[\033[0;97m\]"
Time12h="\T"
Host="\h"
Color_Off="\[\033[0m\]"
PathShort="\w"
IRed="\[\033[0;91m\]"
Green="\[\033[0;32m\]"
Turquoise="\[\033[38;5;6m\]"
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export PS1=$IWhite$Host": "$Turquoise"["$PathShort"]"$Color_Off'$(git branch &>/dev/null;\
if [ $? -eq 0 ]; then \
  echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
  if [ "$?" -eq "0" ]; then \
    # @4 - Clean repository - nothing to commit
    echo "'$Green'"$(__git_ps1 " (%s)"); \
  else \
    # @5 - Changes to working tree
    echo "'$IRed'"$(__git_ps1 " {%s}"); \
  fi) '$Color_Off'\$ "; \
else \
  # @2 - Prompt when not in GIT repo
  echo " '$Color_Off'\$ "; \
fi)'


# Misc
if [ $(uname) = 'Darwin' ]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
    fi
fi

if [ -f /usr/local/etc/bash_completion ]; then . /usr/local/etc/bash_completion; fi
if [ -f ~/.git-completion.bash ]; then . ~/.git-completion.bash; fi

# Start ssh-agent
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# Start sway
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then exec sway ; fi
