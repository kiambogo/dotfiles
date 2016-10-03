# Aliases

alias ll='ls -al'

# Environment Variables


# Sourced files


# Functions

function awstoken() {
    docker run --rm -t -i -v ~/.aws:/root/.aws docker-registry.gilt.com/infra-aws-saml:latest
}


# Shell Customization

LOCALHOST="wl6391"

BLUE="033"
RED="196"
ORANGE="166"
GREEN="10"
YELLOW="11"
GIT_RED="\[\033[0;91m\]"
GIT_GREEN="\[\033[0;32m\]"

PATH_SHORT="\w"
COLOR_RESET="\[\033[0m\]"

# Color the hostname
if [ $HOSTNAME = $LOCALHOST ]; then
    export HOST_COLOR=$ORANGE
fi
if [[ $(hostname -s) = dbapp1* ]]; then
    # DBApp1
    export HOST_COLOR=$RED
fi
if [[ $(hostname -s) = ip* ]]; then
    # AWS box
    export HOST_COLOR=$YELLOW
fi

export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

export PS1='\[\033[38;5;`echo $HOST_COLOR`m\]\h\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\]\[\033[38;5;6m\][\w]\[$(tput sgr0)\]\[\033[38;5;15m\]\[$(git branch &>/dev/null; \
    if [ $? -eq 0 ]; then \
    echo "$(echo `git status` | grep "nothing to commit" > /dev/null 2>&1; \
         if [ "$?" -eq "0" ]; then \
            echo "'$GIT_GREEN'"$(__git_ps1 " (%s)"); \
         else \
            echo "'$GIT_RED'"$(__git_ps1 " {%s}"); \
         fi)"; \
    fi)\]\[\033[0m \\$ \[$(tput sgr0)\]'


# Misc
if [ $(uname) = 'Darwin' ]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
    fi
fi


### Bashhub.com Installation.
### This Should be at the EOF. https://bashhub.com/docs
if [ -f ~/.bashhub/bashhub.sh ]; then
    source ~/.bashhub/bashhub.sh
fi

