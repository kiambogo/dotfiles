# Aliases

alias ll='ls -al'
source ~/.aliases
source ~/.tokens

alias prod_console='ssh -t job15.prod.ec2.gilt.local "sudo docker exec -it \`sudo docker ps -q | head -1\` bash -c \". ~/.profile ; script/console\""'
alias j8="export JAVA_HOME=`/usr/libexec/java_home -v 1.8`; java -version"
alias j7="export JAVA_HOME=`/usr/libexec/java_home -v 1.7`; java -version"
alias j6="export JAVA_HOME=`/usr/libexec/java_home -v 1.6`; java -version"

# Environment Variables
export FZF_DEFAULT_COMMAND='ag -g ""'
export ADMIN_TOKEN='a21ee536e0937f891ecad4b9ceefa7ff'
#export EDITOR='vim'


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
    fi)\]\[\033[0m\] \\$ \[$(tput sgr0)\]'


# Misc
if [ $(uname) = 'Darwin' ]; then
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
      . $(brew --prefix)/etc/bash_completion
    fi
fi

export PATH=/web/tools/bin:$HOME/.rbenv/bin:/usr/local/lib/apidoc-cli-master/bin:$PATH

eval "$(rbenv init -)"

### Bashhub.com Installation.
### This Should be at the EOF. https://bashhub.com/docs
if [ -f ~/.bashhub/bashhub.sh ]; then
    source ~/.bashhub/bashhub.sh
fi

export PATH="$PATH:/web/util-eng/bin:/web/tools/bin"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
