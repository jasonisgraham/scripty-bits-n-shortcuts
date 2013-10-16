#!/bin/bash

# BASH_FILES_DIR will be equal to the dir holding this file
BASH_FILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# I do not need to be bothered with the shift key
set completion-ignore-case on

# xports
export IGNOREEOF=1
export PS1="\u \w> "
export EDITOR='emacs -nw'

# binds
bind 'set completion-ignore-case on'
bind '"\eS"':"\"source ~/.bashrc\C-m\"" # alt-S loads source
bind '"\ej"':"\"\eb\"";                 # alt-j moves cursor back word
bind '"\ek"':"\"\ef\""                  # alt-k moves cursor forward word
bind '"\eJ"':"\"\C-w\"";                # alt-J cuts word behind cursor
bind '"\eK"':"\"\ed\""                  # alt-K cuts word in front of cursor
bind '"\e<"':"\"\C-ubind-U\C-m\""       # alt-U Move up the directory. same as cd ../
bind '"\e>"':"\"\C-ubind-F\C-m\""       # alt-f Move down the directory.
bind '"\eL"':"\"\C-uls-type\C-m\""      # alt-L same as ls
bind '"\ew"':kill-region

# aliases
alias ll='ls -AlF'
alias la='ls -A'
alias l='ls -CF'
alias lah='ls -lAh'
alias emacs='emacs -nw'
alias irb='irb --simple-prompt'
alias lah='ls -lAh'
alias rm='rm -i'
alias df='df -h'
alias du='du -sh'
alias h='history | tail'

# sources
if [ -a $BASH_FILES_DIR/bash_customizations_git.sh ]; then
    source $BASH_FILES_DIR/bash_customizations_git.sh
fi

# THUMB BALL MOUSE ES 2 FASTO! SLOW IT DOWN
logitech=$(xinput --list --short | grep -m1 "Logitech" | cut -f2 | cut -d= -f2) # mouse ID
xinput --set-prop "$logitech" "Device Accel Constant Deceleration" 2 # It defaults to 1

##########################
#HISTORY_CUSTOMIZATIONS
##########################
HISTCONTROL=ignoredups:ignorespace # don't put duplicate lines in the history.
shopt -s histappend # append to the history file, don't overwrite it
HISTSIZE=1000 # for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILESIZE=2000

##################################
# Common useful functions
##################################
function bind-U {
    pushd . >> /dev/null
    cd ../
}

function bind-F {
    popd >> /dev/null
}

function ls-type {
    read -n 1 -s _type
    ls_cmd='ls -glhBAF --ignore=#* --ignore=.svn --color=always'
    case $_type in
        "h" )
        ;;
        "t" ) # sort by modification time
            ls_cmd="$ls_cmd -t"
        ;;
        "s" ) # sort by file size
            ls_cmd="$ls_cmd -S"
        ;;
        *)
            ls_cmd="ls --color=always"
        ;;
    esac
    $ls_cmd
}

HAVE_SOURCED_GENERAL_BASH_CUSTOMIZATIONS=1

